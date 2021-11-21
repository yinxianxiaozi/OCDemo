//
//  main.m
//  Block的学习
//
//  Created by 张文艺 on 2021/11/5.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

//C函数实现
int func(int arg) {
    return arg;
};

typedef int (*funcPtr)(int);

typedef int (^tmpBlock)(int arg);

/*
 通过C函数和block的实现对比可以发现，C函数和block的声明定义基本一样，只是在实现block时没有名称，而函数是有名称的。
 */

void niminghanshu(int arg){
    //C函数指针赋值
    funcPtr ptr = *func;
    //C函数指针调用
    int ret1 = ptr(10);

    //block指针赋值
    tmpBlock block = ^(int arg){
        return arg;
    };
    //block调用
    int ret2 = block(10);
    NSLog(@"ret1:%d---ret2:%d",ret1,ret2);
}

//block内只使用不赋值，不需要加__block
void test(){
    int b = 10;
    void (^block2)(void) = ^{
        NSLog(@"wenyi--b:%d",b);
    };
    
    block2();
}


int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    
//    niminghanshu(2);
    test();
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
