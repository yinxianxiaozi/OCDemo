//
//  NSObject+LGKVO.m
//  003---自定义KVO
//
//  Created by cooci on 2019/1/5.
//  Copyright © 2019 cooci. All rights reserved.
//

#import "NSObject+LGKVO.h"
#import <objc/message.h>

static NSString *const kLGKVOPrefix = @"LGKVONotifying_";
static NSString *const kLGKVOAssiociateKey = @"kLGKVO_AssiociateKey";

@implementation NSObject (LGKVO)

- (void)lg_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context{
    
    // 自定义KVO
    // 1: 模拟系统
    // 2: 移除观察者 - 自动移除
    // 3: 响应式+函数式
    
    // 1: 验证是否存在setter方法 : 不让实例进来
    [self judgeSetterMethodFromKeyPath:keyPath];
    // 2: 动态生成子类
    Class newClass = [self createChildClassWithKeyPath:keyPath];
    //  2.1 申请类
    //  2.2 注册
    //  2.3 添加方法
    // 3: isa 指向
    object_setClass(self, newClass);
    // 4: 父类 setter
    // 5: 观察者去响应
    
    

}

#pragma mark - 验证是否存在setter方法
- (void)judgeSetterMethodFromKeyPath:(NSString *)keyPath{
    Class superClass    = object_getClass(self);
    SEL setterSeletor   = NSSelectorFromString(setterForGetter(keyPath));
    Method setterMethod = class_getInstanceMethod(superClass, setterSeletor);
    if (!setterMethod) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"老铁没有当前%@的setter",keyPath] userInfo:nil];
    }
}

#pragma mark -
- (Class)createChildClassWithKeyPath:(NSString *)keyPath{
    
    NSString *oldClassName = NSStringFromClass([self class]);
    NSString *newClassName = [NSString stringWithFormat:@"%@%@",kLGKVOPrefix,oldClassName];
    Class newClass = NSClassFromString(newClassName);
    if (newClass) return newClass;
    // kLGKVOPrefix
    //  2.1 申请类
    newClass = objc_allocateClassPair([self class], newClassName.UTF8String, 0);
    //  2.2 注册
    objc_registerClassPair(newClass);
    //  2.3 添加方法 - 属性 - ivar - ro
    
    SEL setterSel = NSSelectorFromString(setterForGetter(keyPath));
    Method method = class_getInstanceMethod([self class], setterSel);
    const char *type = method_getTypeEncoding(method);
    class_addMethod(newClass, setterSel, (IMP)lg_setter, type);
    
    return newClass;
}

// 子类重写的imp - 自己预习
static void lg_setter(id self,SEL _cmd,id newValue){
    NSLog(@"来了:%@",newValue);
}

Class lg_class(id self,SEL _cmd){
    return class_getSuperclass(object_getClass(self));
}

#pragma mark - 从get方法获取set方法的名称 key ===>>> setKey:
static NSString *setterForGetter(NSString *getter){
    
    if (getter.length <= 0) { return nil;}
    
    NSString *firstString = [[getter substringToIndex:1] uppercaseString];
    NSString *leaveString = [getter substringFromIndex:1];
    
    return [NSString stringWithFormat:@"set%@%@:",firstString,leaveString];
}

#pragma mark - 从set方法获取getter方法的名称 set<Key>:===> key
static NSString *getterForSetter(NSString *setter){
    
    if (setter.length <= 0 || ![setter hasPrefix:@"set"] || ![setter hasSuffix:@":"]) { return nil;}
    
    NSRange range = NSMakeRange(3, setter.length-4);
    NSString *getter = [setter substringWithRange:range];
    NSString *firstString = [[getter substringToIndex:1] lowercaseString];
    return  [getter stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:firstString];
}


@end
