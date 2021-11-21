//
//  GCDTest.m
//  多线程使用
//
//  Created by 张文艺 on 2021/10/24.
//

#import "GCDTest.h"

@implementation GCDTest
{
    dispatch_queue_t queue;
    dispatch_queue_t queue2;
    dispatch_queue_t queue3;
    dispatch_queue_t queue4;
    dispatch_queue_t queue5;
}

- (void)createQueueTest{
    //创建队列
    queue = dispatch_queue_create("串行队列", DISPATCH_QUEUE_SERIAL);
    queue2 = dispatch_queue_create("并发队列", DISPATCH_QUEUE_CONCURRENT);
    queue3 = dispatch_queue_create("串行队列", NULL);
    //获取已有队列
    //获取主队列
    queue4 = dispatch_get_main_queue();
    //获取全局并发队列
    /*
     第一个参数是优先级，第二个无意义，填0
     */
    queue5 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
}

- (void)createTaskTest{
    /*
//     参数一：队列
//     参数二：作为任务的block代码
//     */
//    dispatch_async(dispatch_queue_t  _Nonnull queue, <#^(void)block#>);
//    /*
//     参数一：队列
//     参数二：上下文
//     参数三：作为任务的函数
//     */
//    dispatch_async_f(<#dispatch_queue_t  _Nonnull queue#>, <#void * _Nullable context#>, <#dispatch_function_t  _Nonnull work#>);
//
//    /*
//     参数一：队列
//     参数二：作为任务的block代码
//     */
//    dispatch_sync(dispatch_queue_t  _Nonnull queue, <#^(void)block#>);
//    /*
//     参数一：队列
//     参数二：上下文
//     参数三：作为任务的函数
//     */
//    dispatch_sync_f(<#dispatch_queue_t  _Nonnull queue#>, <#void * _Nullable context#>, <#dispatch_function_t  _Nonnull work#>);
}

/**
 主队列同步
 不会开线程
 */
- (void)mainSyncTest{
    
    NSLog(@"0");
    // 等
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"1");
    });
    NSLog(@"2");
}

/**
 主队列异步
 不会开线程 顺序
 */
- (void)mainAsyncTest{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"1");
    });
    NSLog(@"2");
}
/**
 全局异步
 全局队列:一个并发队列
 */
- (void)globalAsyncTest{
    
    for (int i = 0; i<20; i++) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSLog(@"%d-%@",i,[NSThread currentThread]);
        });
    }
    NSLog(@"hello queue");
}

/**
 全局同步
 全局队列:一个并发队列
 */
- (void)globalSyncTest{
    for (int i = 0; i<20; i++) {
        dispatch_sync(dispatch_get_global_queue(0, 0), ^{
            NSLog(@"%d-%@",i,[NSThread currentThread]);
        });
    }
    NSLog(@"hello queue--%@",[NSThread currentThread]);
    NSLog(@"main--%@",[NSThread mainThread]);
}

#pragma mark - 队列函数的应用

- (void)textDemo2{
    // 同步队列
    dispatch_queue_t queue = dispatch_queue_create("cooci", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"1");
    // 异步函数
    dispatch_async(queue, ^{
        NSLog(@"2");
        // 同步
        dispatch_sync(queue, ^{
        });
    });
    NSLog(@"5");

}

- (void)textDemo1{
    
    dispatch_queue_t queue = dispatch_queue_create("cooci", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"1");
    dispatch_async(queue, ^{
        NSLog(@"2");
        dispatch_sync(queue, ^{
            NSLog(@"3");
        });
        NSLog(@"4");
    });
    NSLog(@"5");

}

- (void)textDemo3{
    
    dispatch_queue_t queue = dispatch_queue_create("cooci", NULL);
    NSLog(@"1");
    // 耗时
    dispatch_async(queue, ^{
        NSLog(@"2");
        dispatch_async(queue, ^{
            NSLog(@"3");
        });
        NSLog(@"4");
    });
    NSLog(@"5");
}

- (void)textDemo{
    
    dispatch_queue_t queue = dispatch_queue_create("cooci", NULL);
    NSLog(@"1---%@",[NSThread currentThread]);
    // 耗时
    dispatch_async(queue, ^{
        NSLog(@"2---%@",[NSThread currentThread]);
        dispatch_async(queue, ^{
            NSLog(@"3---%@",[NSThread currentThread]);
        });
        NSLog(@"4---%@",[NSThread currentThread]);
    });
    NSLog(@"5---%@",[NSThread currentThread]);
}

/**
 同步并发 : 堵塞 同步锁  队列 : resume supend   线程 操作, 队列挂起 任务能否执行
 */
- (void)concurrentSyncTest{

    //1:创建并发队列
    dispatch_queue_t queue = dispatch_queue_create("Cooci", DISPATCH_QUEUE_CONCURRENT);
    for (int i = 0; i<20; i++) {
        dispatch_sync(queue, ^{
            NSLog(@"%d-%@",i,[NSThread currentThread]);
        });
    }
    NSLog(@"hello queue");
}


/**
 异步并发: 有了异步函数不一定开辟线程
 */
- (void)concurrentAsyncTest{
    //1:创建并发队列
    dispatch_queue_t queue = dispatch_queue_create("Cooci", DISPATCH_QUEUE_CONCURRENT);
    for (int i = 0; i<20; i++) {
        dispatch_async(queue, ^{
            NSLog(@"%d-%@",i,[NSThread currentThread]);
        });
    }
    NSLog(@"hello queue");
}

/**
 串行异步队列

 */
- (void)serialAsyncTest{
    //1:创建串行队列
    dispatch_queue_t queue = dispatch_queue_create("Cooci", DISPATCH_QUEUE_SERIAL);
    for (int i = 0; i<20; i++) {
        dispatch_async(queue, ^{
            NSLog(@"%d-%@",i,[NSThread currentThread]);
        });
    }
    
    NSLog(@"hello queue");
}

/**
 串行同步队列 : FIFO: 先进先出
 */
- (void)serialSyncTest{
    //1:创建串行队列
    dispatch_queue_t queue = dispatch_queue_create("Cooci", DISPATCH_QUEUE_SERIAL);
    for (int i = 0; i<20; i++) {
        dispatch_sync(queue, ^{
            NSLog(@"%d-%@",i,[NSThread currentThread]);
        });
    }

}


/**
 * 还原最基础的写法,很重要
 */

- (void)syncTest{
    // 把任务添加到队列 --> 函数
    // 任务 _t ref c对象
    dispatch_block_t block = ^{
        NSLog(@"hello GCD");
    };
    //串行队列
    dispatch_queue_t queue = dispatch_queue_create("com.lg.cn", NULL);
    // 函数
    dispatch_async(queue, block);
    
}

- (void)wbinterDemo{
    dispatch_queue_t queue11 = dispatch_queue_create("wy", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue11, ^{
        NSLog(@"1");
    });
    dispatch_async(queue11, ^{
        NSLog(@"2");
    });
    dispatch_sync(queue11, ^{
        NSLog(@"3");
    });
    NSLog(@"0");
    dispatch_async(queue11, ^{
        NSLog(@"1");
    });
    dispatch_async(queue11, ^{
        NSLog(@"7");
    });
    dispatch_async(queue11, ^{
        NSLog(@"8");
    });
    dispatch_async(queue11, ^{
        NSLog(@"9");
    });
    
//      A:1230789
//      B:1237890
//      C:3120798
//      D:2137890
}


- (void)cjl_testGroup2{
    /*
     dispatch_group_enter和dispatch_group_leave成对出现，使进出组的逻辑更加清晰
     */
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        NSLog(@"请求一完成");
        dispatch_group_leave(group);
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"刷新界面");
    });
    
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        NSLog(@"请求二完成");
        dispatch_group_leave(group);
    });
    
    
}

- (void)cjl_testGroup3{
    /*
     long dispatch_group_wait(dispatch_group_t group, dispatch_time_t timeout)

     group：需要等待的调度组
     timeout：等待的超时时间（即等多久）
        - 设置为DISPATCH_TIME_NOW意味着不等待直接判定调度组是否执行完毕
        - 设置为DISPATCH_TIME_FOREVER则会阻塞当前调度组，直到调度组执行完毕


     返回值：为long类型
        - 返回值为0——在指定时间内调度组完成了任务
        - 返回值不为0——在指定时间内调度组没有按时完成任务

     */
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        NSLog(@"请求一完成");
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        NSLog(@"请求二完成");
        dispatch_group_leave(group);
    });
    
//    long timeout = dispatch_group_wait(group, DISPATCH_TIME_NOW);
//    long timeout = dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    long timeout = dispatch_group_wait(group, dispatch_time(DISPATCH_TIME_NOW, 1 *NSEC_PER_SEC));
    NSLog(@"timeout = %ld", timeout);
    if (timeout == 0) {
        NSLog(@"按时完成任务");
    }else{
        NSLog(@"超时");
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"刷新界面");
    });
}

//栅栏函数
- (void)cjl_testBarrier{
    /*
     dispatch_barrier_sync & dispatch_barrier_async
     
     应用场景：同步锁
     
     等栅栏前追加到队列中的任务执行完毕后，再将栅栏后的任务追加到队列中。
     简而言之，就是先执行栅栏前任务，再执行栅栏任务，最后执行栅栏后任务
     
     - dispatch_barrier_async：前面的任务执行完毕才会来到这里
     - dispatch_barrier_sync：作用相同，但是这个会堵塞线程，影响后面的任务执行
    
     - dispatch_barrier_async可以控制队列中任务的执行顺序，
     - 而dispatch_barrier_sync不仅阻塞了队列的执行，也阻塞了线程的执行（尽量少用）
     */
    
//    [self cjl_testBarrier1];
    [self cjl_testBarrier2];
}

//同步栅栏函数dispatch_barrier_sync
- (void)cjl_testBarrier1{
    dispatch_queue_t queue = dispatch_queue_create("CJL", DISPATCH_QUEUE_CONCURRENT);
    
    NSLog(@"开始 - %@", [NSThread currentThread]);
    dispatch_async(queue, ^{
        sleep(2);
        NSLog(@"延迟2s的任务1 - %@", [NSThread currentThread]);
    });
    NSLog(@"第一次结束 - %@", [NSThread currentThread]);
    
    //栅栏函数的作用是将队列中的任务进行分组，所以我们只要关注任务1、任务2
    dispatch_barrier_sync(queue, ^{
        sleep(1);
        NSLog(@"------------延迟1s的栅栏任务------------%@", [NSThread currentThread]);
    });
    NSLog(@"栅栏结束 - %@", [NSThread currentThread]);
    
    dispatch_async(queue, ^{
        NSLog(@"不延迟的任务2 - %@", [NSThread currentThread]);
    });
    NSLog(@"第二次结束 - %@", [NSThread currentThread]);
}
//异步栅栏函数dispatch_barrier_async
- (void)cjl_testBarrier2{
    //并发队列使用栅栏函数
    
    dispatch_queue_t queue = dispatch_queue_create("CJL", DISPATCH_QUEUE_CONCURRENT);
    
    NSLog(@"开始 - %@", [NSThread currentThread]);
    dispatch_async(queue, ^{
        sleep(2);
        NSLog(@"延迟2s的任务1 - %@", [NSThread currentThread]);
    });
    NSLog(@"第一次结束 - %@", [NSThread currentThread]);
    
    //由于并发队列异步执行任务是乱序执行完毕的，所以使用栅栏函数可以很好的控制队列内任务执行的顺序
    dispatch_barrier_async(queue, ^{
        sleep(1);
        NSLog(@"------------延迟1s的栅栏任务------------%@", [NSThread currentThread]);
    });
    NSLog(@"栅栏结束 - %@", [NSThread currentThread]);
    
    dispatch_async(queue, ^{
        NSLog(@"不延迟的任务2 - %@", [NSThread currentThread]);
    });
    NSLog(@"第二次结束 - %@", [NSThread currentThread]);
}

- (void)cjl_testSemaphore{
    /*
     应用场景：同步当锁, 控制GCD最大并发数

     - dispatch_semaphore_create()：创建信号量
     - dispatch_semaphore_wait()：等待（减少）信号量，信号量减1。当信号量< 0时会阻塞当前线程，根据传入的等待时间决定接下来的操作——如果永久等待将等到有信号（信号量>=0）才可以执行下去
     - dispatch_semaphore_signal()：递增信号量，信号量加1。当信号量>= 0 会执行dispatch_semaphore_wait中等待的任务

     */
    dispatch_queue_t queue = dispatch_queue_create("CJL", DISPATCH_QUEUE_CONCURRENT);
    
    for (int i = 0; i < 10; i++) {
        dispatch_async(queue, ^{
            NSLog(@"当前 - %d， 线程 - %@", i, [NSThread currentThread]);
        });
    }
    
    //利用信号量来改写
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    
    for (int i = 0; i < 10; i++) {
        dispatch_async(queue, ^{
            NSLog(@"当前 - %d， 线程 - %@", i, [NSThread currentThread]);
            
            dispatch_semaphore_signal(sem);
        });
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    }
}

- (void)testAfter{
    NSLog(@"第一步");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"我是延迟执行的函数 ---%@",[NSThread currentThread]);
    });
    
    NSLog(@"耗时任务开始");
    NSInteger count = 0;
    for (long long i = 0; i < 5000000000; i++)
    {
        count ++;
    }
    NSLog(@"耗时任务结束");
}

- (void)cjl_testSource{
    /*
     dispatch_source
     
     应用场景：GCDTimer
     在iOS开发中一般使用NSTimer来处理定时逻辑，但NSTimer是依赖Runloop的，而Runloop可以运行在不同的模式下。如果NSTimer添加在一种模式下，当Runloop运行在其他模式下的时候，定时器就挂机了；又如果Runloop在阻塞状态，NSTimer触发时间就会推迟到下一个Runloop周期。因此NSTimer在计时上会有误差，并不是特别精确，而GCD定时器不依赖Runloop，计时精度要高很多
     
     dispatch_source是一种基本的数据类型，可以用来监听一些底层的系统事件
        - Timer Dispatch Source：定时器事件源，用来生成周期性的通知或回调
        - Signal Dispatch Source：监听信号事件源，当有UNIX信号发生时会通知
        - Descriptor Dispatch Source：监听文件或socket事件源，当文件或socket数据发生变化时会通知
        - Process Dispatch Source：监听进程事件源，与进程相关的事件通知
        - Mach port Dispatch Source：监听Mach端口事件源
        - Custom Dispatch Source：监听自定义事件源

     主要使用的API：
        - dispatch_source_create: 创建事件源
        - dispatch_source_set_event_handler: 设置数据源回调
        - dispatch_source_merge_data: 设置事件源数据
        - dispatch_source_get_data： 获取事件源数据
        - dispatch_resume: 继续
        - dispatch_suspend: 挂起
        - dispatch_cancle: 取消
     */
    
    //1.创建队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    //2.创建timer
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //3.设置timer首次执行时间，间隔，精确度
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 2.0*NSEC_PER_SEC, 0.1*NSEC_PER_SEC);
    //4.设置timer事件回调
    dispatch_source_set_event_handler(timer, ^{
        NSLog(@"GCDTimer");
    });
    //5.默认是挂起状态，需要手动激活
    dispatch_resume(timer);
    
}

@end
