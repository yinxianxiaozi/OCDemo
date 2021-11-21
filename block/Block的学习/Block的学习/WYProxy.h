//
//  WYProxy.h
//  Block的学习
//
//  Created by 张文艺 on 2021/11/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WYProxy : NSProxy
//转换为objc
- (id)transformObjc:(NSObject *)objc;
@end

NS_ASSUME_NONNULL_END
