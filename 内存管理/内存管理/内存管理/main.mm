//
//  main.m
//  内存管理
//
//  Created by 张文艺 on 2021/11/9.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

//包括构造函数和析构函数
struct WYTest{
    WYTest(){
        printf("作用域开始 - %s\n", __func__);
    }
    ~WYTest(){
        printf("作用域结束 - %s\n", __func__);
    }
};

int main(int argc, char * argv[]) {
    
    {
        printf("WY:嘿嘿-作用域前 - %s\n", __func__);
        WYTest test;
        printf("WY：哈哈-作用域中 - %s\n", __func__);
    }
    printf("WY：嘻嘻- 作用域后 - %s\n", __func__);
    NSString * appDelegateClassName;
    @autoreleasepool {
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
