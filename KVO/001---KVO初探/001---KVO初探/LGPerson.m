//
//  LGPerson.m
//  001---KVO初探
//
//  Created by cooci on 2019/1/3.
//  Copyright © 2019 cooci. All rights reserved.
//

#import "LGPerson.h"

@implementation LGPerson

// 下载进度 -- writtenData/totalData

//系统方法
+ (NSSet<NSString *> *)keyPathsForValuesAffectingValueForKey:(NSString *)key{
    
    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
    //判断是真正要监听的那个属性
    if ([key isEqualToString:@"downloadProgress"]) {
        //添加keyPaths，这个数组里的每个属性发生变化都会响应观察
        NSArray *affectingKeys = @[@"totalData", @"writtenData"];
        keyPaths = [keyPaths setByAddingObjectsFromArray:affectingKeys];
    }
    return keyPaths;
}

// 自动开关
+ (BOOL) automaticallyNotifiesObserversForKey:(NSString *)key{
//    return YES;//自动
    return NO;//手动，自己写setter
}

- (NSString *)downloadProgress{
    if (self.writtenData == 0) {
        self.writtenData = 10;
    }
    if (self.totalData == 0) {
        self.totalData = 100;
    }
    return [[NSString alloc] initWithFormat:@"%f",1.0f*self.writtenData/self.totalData];
}

//这两个方法都是系统自动监听时要使用的方法，如果不自动监听，就需要我们自己加了。
- (void)setNick:(NSString *)nick{
    [self willChangeValueForKey:@"nick"];
    _nick = nick;
    [self didChangeValueForKey:@"nick"];
}

- (void)insertObject:(id)object inDateArrayAtIndex:(NSUInteger)index{
    [self.dateArray insertObject:object atIndex:index];
}

-(void)removeObjectFromDateArrayAtIndex:(NSUInteger)index{
    [self.dateArray removeObjectAtIndex:index];
}

@end
