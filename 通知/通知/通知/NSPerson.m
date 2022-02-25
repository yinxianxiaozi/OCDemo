//
//  NSPerson.m
//  通知
//
//  Created by 张文艺 on 2021/11/23.
//

#import "NSPerson.h"

@implementation NSPerson


- (void)drink{
    NSLog(@"%s:drink",__func__);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"eat" object:nil];
}

@end
