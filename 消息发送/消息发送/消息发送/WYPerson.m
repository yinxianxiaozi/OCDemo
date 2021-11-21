//
//  WYPerson.m
//  消息发送
//
//  Created by 张文艺 on 2021/10/13.
//

#import "WYPerson.h"
#import "WYCat.h"
#import "objc/runtime.h"
#import "objc/message.h"

@implementation WYPerson

- (void)msgSendTest:(BOOL)abc{
    NSLog(@"测试objc_msgSend");
}

- (void) msgSendSuperTest {
    NSLog(@"%s： 测试objc_msgSendSuper",__func__);
}


- (void) runtimeTest{
    /*
     1、定义一个函数
     2、通过mehtodForSelector获取一个方法的函数指针IMP
     3、直接调用该函数
     */
    //参数1：接收消息的对象
    //参数2：方法选择器，也就是方法名
    //参数3：方法参数
    void (*setter)(id,SEL,BOOL);
    setter = (void (*)(id,SEL,BOOL))[self methodForSelector:@selector(test:)];
    for (int i=0; i<10;i++) {
        setter(self,@selector(test:),YES);
    }
}

- (void)test:(BOOL)isTest{
    NSLog(@"我是一个OC方法，被当做C函数直接调用了");
}


//实例方法的动态方法解析
/*
 如果给该sel添加了imp，则直接执行
 如果没有添加成功，不管返回的YES还是NO，都会执行消息转发
 */
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    //mehtodDynamically方法在.h中声明了，但是没有在.m文件中定义
    if (sel == @selector(mehtodDynamically)) {
        //这里的参数很重要，具体情况具体看
        //给一个类添加方法，参数分别是类名、方法选择器、IMP，参数类型（涉及到类型编码）
        class_addMethod([self class],sel,(IMP)resolveInstanceMethodTest,"v@:");
        return YES;
    }
    if (sel == @selector(eat)) {
        return NO;
    }
    return [super resolveInstanceMethod:sel];
}

//类方法的动态方法解析也一样
//+ (BOOL)resolveClassMethod:(SEL)sel{
//
//}

//这里的参数必须这样写，因为底层本来就是这样写的。保持一致。
void resolveInstanceMethodTest(id self,SEL _cmd){
    NSLog(@"大家好，我是一个被动态解析的作为mehtodDynamically实现函数");
}

//返回接受者对象
- (id)forwardingTargetForSelector:(SEL)aSelector{
//    if (aSelector == @selector(eat)) {
//        return [[WYCat alloc]init];
//    }
//    return [super forwardingTargetForSelector:aSelector];
    return nil;
}


/*
 返回一个方法签名对象，表示这个函数的返回值类型和参数类型
 */
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if ([NSStringFromSelector(aSelector) isEqualToString:@"eat"]) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }

    return [super methodSignatureForSelector:aSelector];
}

//forwardInvoWYCation通知当前对象，并将NSInvoWYCation消息传递过来
/*
 有两个要点：
    1、决定消息接收者
    2、转发
 */
- (void)forwardInvocation:(NSInvocation *)anInvocation{
    //1、消息接收者

    WYCat *cat = [[WYCat alloc] init];
    //anInvoWYCation表示消息，获取该消息的方法选择器

    if ([cat respondsToSelector:[anInvocation selector]]) {
        //重新指向接受者并唤醒
//        [anInvocation invokeWithTarget:cat];
        
        //重新指向消息接收者
//        anInvocation.target = cat;
        
        //重新指向选择器
        anInvocation.selector = @selector(forwardInvocationTest);
        //唤醒
        [anInvocation invoke];
    } else {
        [super forwardInvocation:anInvocation];
    }

}

- (void)forwardInvocationTest{
    NSLog(@"大家好，我是一个消息重定向的的实现函数，如果找不到eat函数，就会执行我");
}



- (void)getcatProperty{
    id className = objc_getClass("WYCat");//这里传入的是C字符串
    unsigned int coutCount, i;

    objc_property_t *properties = class_copyPropertyList(className, &coutCount);

    for (i=0; i<coutCount; i++) {
        objc_property_t property = properties[i];
        //这里得到的是C字符串
        NSLog(@"得到的属性名:%s--属性：%s",property_getName(property),property_getAttributes(property));
    }
}

@end
