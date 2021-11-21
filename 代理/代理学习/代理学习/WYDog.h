//
//  WYDog.h
//  代理学习
//
//  Created by 张文艺 on 2021/11/12.
//

#import <Foundation/Foundation.h>
#import "WYEatFood.h"

NS_ASSUME_NONNULL_BEGIN

@interface WYDog : NSObject<WYEatFood>
//设置代理对象，delegate就是遵守了WYEatFood协议的一个对象
@property (nonatomic, weak) id<WYEatFood> delegate;
@end

NS_ASSUME_NONNULL_END
