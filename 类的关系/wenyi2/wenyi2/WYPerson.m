//
//  WYPerson.m
//  wenyi2
//
//  Created by 张文艺 on 2021/7/19.
//

#import "WYPerson.h"

@implementation WYPerson

+ (void)load{
    NSLog(@"%s",__func__);
}

- (void)eat {
    NSAssert(NO, @"我错了");
    NSAssert1(NO, @"我错了---%@", @"开始");
}

- (void)drink:(NSString *)car {
    NSParameterAssert(car);
}

@end
