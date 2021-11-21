//
//  WYDog.m
//  代理学习
//
//  Created by 张文艺 on 2021/11/12.
//

#import "WYDog.h"
/*
 WYDog作为委托类，它的eatFood方法委托给WYcat来执行。
 */

@implementation WYDog

//让代理对象delegate来执行eatFood方法
- (void)eatFood{
    //在执行前先判断是否存在该方法
    if ([self.delegate respondsToSelector:@selector(eatFood)]) {
        [self.delegate eatFood];
    }
}
@end
