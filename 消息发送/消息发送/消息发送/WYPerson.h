//
//  WYPerson.h
//  消息发送
//
//  Created by 张文艺 on 2021/10/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WYPerson : NSObject

@property (nonatomic ,assign ,readonly) int age;
@property (nonatomic ,copy,readwrite) NSString *name;

- (void) runtimeTest;
- (void)mehtodDynamically;//没有方法实现
- (void)eat;
- (void)getCatProperty;
- (void) msgSendSuperTest;
- (void) forwardInvocationTest;
@end

NS_ASSUME_NONNULL_END
