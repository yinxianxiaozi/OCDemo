//
//  WYProxy.h
//  NSProxy虚拟类
//
//  Created by 张文艺 on 2021/11/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WYProxy : NSProxy

//转换为objc
- (id)transformObjc:(NSObject *)objc;

//拿到代理对象，也就是自身
+ (instancetype)proxyWithObjc:(id)objc;

@end

NS_ASSUME_NONNULL_END
