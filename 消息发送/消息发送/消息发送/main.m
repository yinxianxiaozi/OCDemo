//
//  main.m
//  消息发送
//
//  Created by 张文艺 on 2021/10/15.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "WYPerson.h"
#import "objc/message.h"
#import "WYStudent.h"
extern void instrumentObjcMessageSends(BOOL flag);


void methodNature(){
    WYPerson *person = [WYPerson alloc];
    objc_msgSend(person,sel_registerName("msgSendTest:"),YES);

    WYStudent *student = [WYStudent alloc];
    [student msgSendSuperTest];

    struct objc_super wySuper;
    wySuper.receiver = person;
    wySuper.super_class = [WYStudent class];

    objc_msgSendSuper(&wySuper, sel_registerName("msgSendSuperTest"));
}

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        
        //objc_msgSendSuper探索
        WYStudent *student = [WYStudent alloc];
//        [student objc_msgSendSuperTest];
        
        //方法本质探索
//        methodNature();
        
        //动态方法解析
//        [student mehtodDynamically];
        
        //消息转发
        WYPerson *person = [WYPerson alloc];
        instrumentObjcMessageSends(YES);
        [person eat];
        instrumentObjcMessageSends(NO);
        NSLog(@"Hello, World!");
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
