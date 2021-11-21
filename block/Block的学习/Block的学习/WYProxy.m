//
//  WYProxy.m
//  Block的学习
//
//  Created by 张文艺 on 2021/11/8.
//

#import "WYProxy.h"

@interface WYProxy ()
@property(nonatomic, weak, readonly) NSObject *objc;
@end

@implementation WYProxy

//代理转换为真实对象，可以看到其实只是一个属性的赋值
- (id)transformObjc:(NSObject *)objc{
   _objc = objc;
    return self;
}

//代理传入的对象
+ (instancetype)proxyWithObjc:(id)objc{
    return  [[self alloc] transformObjc:objc];
}


//返回方法签名
/*
 这里返回的就是需要转发的方法的方法签名
 因为需要转发给其他对象，所以就要返回这个对象的该方法的方法签名
 */
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel{
    NSMethodSignature *signature;
    if (self.objc) {
        signature = [self.objc methodSignatureForSelector:sel];
    }else{
        signature = [super methodSignatureForSelector:sel];
    }
    return signature;
}

//消息转发
//很简单，就是将消息转发给当前虚拟类代理的对象
- (void)forwardInvocation:(NSInvocation *)invocation{
    SEL sel = [invocation selector];
    if ([self.objc respondsToSelector:sel]) {
        [invocation invokeWithTarget:self.objc];
    }
}
@end
