/*
 * Copyright (c) 1999-2007 Apple Inc.  All Rights Reserved.
 * 
 * @APPLE_LICENSE_HEADER_START@
 * 
 * This file contains Original Code and/or Modifications of Original Code
 * as defined in and that are subject to the Apple Public Source License
 * Version 2.0 (the 'License'). You may not use this file except in
 * compliance with the License. Please obtain a copy of the License at
 * http://www.opensource.apple.com/apsl/ and read it before using this
 * file.
 * 
 * The Original Code and all software distributed under the License are
 * distributed on an 'AS IS' basis, WITHOUT WARRANTY OF ANY KIND, EITHER
 * EXPRESS OR IMPLIED, AND APPLE HEREBY DISCLAIMS ALL SUCH WARRANTIES,
 * INCLUDING WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE, QUIET ENJOYMENT OR NON-INFRINGEMENT.
 * Please see the License for the specific language governing rights and
 * limitations under the License.
 * 
 * @APPLE_LICENSE_HEADER_END@
 */

#include "objc-private.h"
#include "objc-sync.h"

//
// Allocate a lock only when needed.  Since few locks are needed at any point
// in time, keep them on a single list.
//


typedef struct alignas(CacheLineSize) SyncData {
    struct SyncData* nextData;//下一个同步数据，这是递归用的，单链表结构
    DisguisedPtr<objc_object> object;//对象的一个封装
    int32_t threadCount;  // number of THREADS using this block 因为可以递归，所以这里可以存储一下进来的线程数量
    recursive_mutex_t mutex;//这就是一个递归互斥锁，包含在这里，可以直接用它来lock和unlock
} SyncData;

typedef struct {
    SyncData *data;
    unsigned int lockCount;  // number of times THIS THREAD locked this block
} SyncCacheItem;

typedef struct SyncCache {
    unsigned int allocated;
    unsigned int used;
    SyncCacheItem list[0];
} SyncCache;

/*
  Fast cache: two fixed pthread keys store a single SyncCacheItem. 
  This avoids malloc of the SyncCache for threads that only synchronize 
  a single object at a time.
  SYNC_DATA_DIRECT_KEY  == SyncCacheItem.data
  SYNC_COUNT_DIRECT_KEY == SyncCacheItem.lockCount
 */

struct SyncList {
    SyncData *data;
    spinlock_t lock;

    constexpr SyncList() : data(nil), lock(fork_unsafe_lock) { }
};

// Use multiple parallel lists to decrease contention among unrelated objects.
#define LOCK_FOR_OBJ(obj) sDataLists[obj].lock
#define LIST_FOR_OBJ(obj) sDataLists[obj].data
static StripedMap<SyncList> sDataLists;


enum usage { ACQUIRE, RELEASE, CHECK };

//全局线程表
static SyncCache *fetch_cache(bool create)
{
    _objc_pthread_data *data;
    
    data = _objc_fetch_pthread_data(create);
    if (!data) return NULL;

    if (!data->syncCache) {
        if (!create) {
            return NULL;
        } else {
            int count = 4;
            data->syncCache = (SyncCache *)
                calloc(1, sizeof(SyncCache) + count*sizeof(SyncCacheItem));
            data->syncCache->allocated = count;
        }
    }

    // Make sure there's at least one open slot in the list.
    if (data->syncCache->allocated == data->syncCache->used) {
        data->syncCache->allocated *= 2;
        data->syncCache = (SyncCache *)
            realloc(data->syncCache, sizeof(SyncCache) 
                    + data->syncCache->allocated * sizeof(SyncCacheItem));
    }

    return data->syncCache;
}


void _destroySyncCache(struct SyncCache *cache)
{
    if (cache) free(cache);
}

/*
 1、
 */
/*
 两种存储方式，一个是线程的单条目的快速缓存（single-entry fast cache），一个是线程的已拥有锁的缓存（cache of already-owned locks）
 只是存储的地方不一样，存储的数据是一样的。
 */

/*
 object是锁对象
 SyncData是用来同步数据，包含了锁对象
 
 lockCount是每个线程中锁对象被锁的次数
 threadCount是锁对象被锁的线程数量
 */

static SyncData* id2data(id object, enum usage why)
{
    spinlock_t *lockp = &LOCK_FOR_OBJ(object);
    SyncData **listp = &LIST_FOR_OBJ(object);
    SyncData* result = NULL;

#if SUPPORT_DIRECT_THREAD_KEYS
    //线程的暂存缓存方式，第一种方式
    // Check per-thread single-entry fast cache for matching object
    //检查每线程单条目快速缓存中是否有匹配的对象
    /*
     tls是本地局部的线程缓存，通过keys来进行存储
     */
    
    /*
     1、先获取到该线程的同步数据
     2、同步数据的锁是否与我们传入的锁一样
     3、如果一样，就修改lockCount
     */
    bool fastCacheOccupied = NO;
    //通过KVC方式对线程进行获取线程绑定的data
    SyncData *data = (SyncData *)tls_get_direct(SYNC_DATA_DIRECT_KEY);
    //如果线程缓存中有data，执行if流程
    if (data) {
        fastCacheOccupied = YES;

        //如果当前线程的锁就是这个锁
        //如果在线程空间中找到了data
        if (data->object == object) {
            // Found a match in fast cache.
            uintptr_t lockCount;

            result = data;
            //通过KVC获取lockCount,lockCount用来记录在当前线程中被锁了几次，
            lockCount = (uintptr_t)tls_get_direct(SYNC_COUNT_DIRECT_KEY);
            if (result->threadCount <= 0  ||  lockCount <= 0) {
                _objc_fatal("id2data fastcache is buggy");
            }

            switch(why) {
            //一个是获取
            //objc_sync_enter走这里，传入的是ACQUIRE -- 获取
            case ACQUIRE: {
                lockCount++;//当前加的锁的数量，被锁了多少次
                tls_set_direct(SYNC_COUNT_DIRECT_KEY, (void*)lockCount);//标记一下当前被锁的次数
                break;
            }
            //一个是释放
            //objc_sync_exit走这里，传入的why是RELEASE -- 释放
            case RELEASE:
                lockCount--;//释放一个锁，就减小1
                tls_set_direct(SYNC_COUNT_DIRECT_KEY, (void*)lockCount);//标记一下当前被锁的次数
                //如果没有锁了，就直接移除这个锁对象
                if (lockCount == 0) {
                    // remove from fast cache
                    tls_set_direct(SYNC_DATA_DIRECT_KEY, NULL);
                    // atomic because may collide with concurrent ACQUIRE
                    OSAtomicDecrement32Barrier(&result->threadCount);
                }
                break;
            case CHECK:
                // do nothing
                break;
            }

            return result;
        }
    }
#endif

    //第二种方式，存储在早已拥有锁的cache中，与存储在线程缓存中的操作是一样的，只是存储的位置不一样。
    // Check per-thread cache of already-owned locks for matching object
    //检查已拥有锁的每个线程缓存中是否存在匹配的对象
    //如果快速缓存中没有，就在已加锁的cache中查找
    //过程与线程缓存是一样的
    SyncCache *cache = fetch_cache(NO);
    if (cache) {
        unsigned int i;
        for (i = 0; i < cache->used; i++) {
            SyncCacheItem *item = &cache->list[i];
            if (item->data->object != object) continue;

            // Found a match.
            result = item->data;
            if (result->threadCount <= 0  ||  item->lockCount <= 0) {
                _objc_fatal("id2data cache is buggy");
            }
                
            switch(why) {
            case ACQUIRE:
                item->lockCount++;
                break;
            case RELEASE:
                item->lockCount--;
                if (item->lockCount == 0) {
                    // remove from per-thread cache
                    cache->list[i] = cache->list[--cache->used];
                    // atomic because may collide with concurrent ACQUIRE
                    OSAtomicDecrement32Barrier(&result->threadCount);
                }
                break;
            case CHECK:
                // do nothing
                break;
            }

            return result;
        }
    }

    // Thread cache didn't find anything.
    // Walk in-use list looking for matching object
    // Spinlock prevents multiple threads from creating multiple 
    // locks for the same new object.
    // We could keep the nodes in some hash table if we find that there are
    // more than 20 or so distinct locks active, but we don't do that now.
    /*
     漫步查找列表的匹配的对象自旋锁可以防止多个线程为同一个新对象创建多个锁
     如果我们发现有超过20个左右的不同锁处于活动状态，我们可以将节点保存在某个哈希表中，但我们现在不这样做。
     */
    //也就是说我们加锁之后就放到列表中，以后再想加锁的时候就先到列表中查找
    /*
     多个线程进入的，会进到这里
     */
    /*
     有三种情况：
     1、第一次进来，没有锁
     2、不是第一次进来，同一个线程加锁
     3、不是第一次进来，不同的线程加锁
     */
    lockp->lock();

    {
        SyncData* p;
        SyncData* firstUnused = NULL;
        //再次查找一下，在这个链表上依次查找
        for (p = *listp; p != NULL; p = p->nextData) {
            //如果存在，
            if ( p->object == object ) {
                result = p;
                // atomic because may collide with concurrent RELEASE
                OSAtomicIncrement32Barrier(&result->threadCount);
                goto done;
            }
            //如果仍然不存在且threadCount == 0，就说明该锁对象还没添加过，
            if ( (firstUnused == NULL) && (p->threadCount == 0) )
                firstUnused = p;
        }
    
        // no SyncData currently associated with object
        if ( (why == RELEASE) || (why == CHECK) )
            goto done;
    
        // an unused one was found, use it
        //第一次进来
        //没有找到，这个result应该就是查找的最终的锁对象
        
        /*
         第一次添加锁对象，将threadCount = 1
         */
        if ( firstUnused != NULL ) {
            result = firstUnused;
            result->object = (objc_object *)object;
            result->threadCount = 1;
            goto done;
        }
    }

    // Allocate a new SyncData and add to list.
    // XXX allocating memory with a global lock held is bad practice,
    // might be worth releasing the lock, allocating, and searching again.
    // But since we never free these guys we won't be stuck in allocation very often.
    //这里是分配一个新的同步数据，并且加到列表上
    posix_memalign((void **)&result, alignof(SyncData), sizeof(SyncData));
    result->object = (objc_object *)object;
    result->threadCount = 1;
    new (&result->mutex) recursive_mutex_t(fork_unsafe_lock);
    result->nextData = *listp;
    *listp = result;
    
    //此处开始缓存锁对象
 done:
    lockp->unlock();
    if (result) {
        // Only new ACQUIRE should get here.
        // All RELEASE and CHECK and recursive ACQUIRE are 
        // handled by the per-thread caches above.
        if (why == RELEASE) {
            // Probably some thread is incorrectly exiting 
            // while the object is held by another thread.
            return nil;
        }
        if (why != ACQUIRE) _objc_fatal("id2data is buggy");
        if (result->object != object) _objc_fatal("id2data is buggy");

//这里也是两种存储位置，第一种是线程的快速缓存区，第二种是线程缓存
#if SUPPORT_DIRECT_THREAD_KEYS
        if (!fastCacheOccupied) {
            // Save in fast thread cache
            //保存快速线程缓存
            tls_set_direct(SYNC_DATA_DIRECT_KEY, result);
            tls_set_direct(SYNC_COUNT_DIRECT_KEY, (void*)1);
        } else 
#endif
        {
            // Save in thread cache
            //保存到线程缓存
            if (!cache) cache = fetch_cache(YES);
            cache->list[cache->used].data = result;
            cache->list[cache->used].lockCount = 1;
            cache->used++;
        }
    }

    return result;
}


BREAKPOINT_FUNCTION(
    void objc_sync_nil(void)
);


// Begin synchronizing on 'obj'. 
// Allocates recursive mutex associated with 'obj' if needed.
// Returns OBJC_SYNC_SUCCESS once lock is acquired.
/*
 开始同步，使用obj锁
 分配递归互斥锁相关的
 
 */
int objc_sync_enter(id obj)
{
    int result = OBJC_SYNC_SUCCESS;

    //锁不能为nil，如果为nil需要
    if (obj) {
        //这个是同步数据
        SyncData* data = id2data(obj, ACQUIRE);
        ASSERT(data);
        data->mutex.lock();//加锁
    } else {
        // @synchronized(nil) does nothing
        if (DebugNilSync) {
            _objc_inform("NIL SYNC DEBUG: @synchronized(nil); set a breakpoint on objc_sync_nil to debug");
        }
        //这里nil直接return掉了，没有做其他操作
        objc_sync_nil();
    }

    return result;
}

BOOL objc_sync_try_enter(id obj)
{
    BOOL result = YES;

    if (obj) {
        SyncData* data = id2data(obj, ACQUIRE);
        ASSERT(data);
        result = data->mutex.tryLock();
    } else {
        // @synchronized(nil) does nothing
        if (DebugNilSync) {
            _objc_inform("NIL SYNC DEBUG: @synchronized(nil); set a breakpoint on objc_sync_nil to debug");
        }
        objc_sync_nil();
    }

    return result;
}


// End synchronizing on 'obj'. 
// Returns OBJC_SYNC_SUCCESS or OBJC_SYNC_NOT_OWNING_THREAD_ERROR
int objc_sync_exit(id obj)
{
    int result = OBJC_SYNC_SUCCESS;
    
    if (obj) {
        SyncData* data = id2data(obj, RELEASE); 
        if (!data) {
            result = OBJC_SYNC_NOT_OWNING_THREAD_ERROR;
        } else {
            bool okay = data->mutex.tryUnlock();
            if (!okay) {
                result = OBJC_SYNC_NOT_OWNING_THREAD_ERROR;
            }
        }
    } else {
        // @synchronized(nil) does nothing
    }
	

    return result;
}

