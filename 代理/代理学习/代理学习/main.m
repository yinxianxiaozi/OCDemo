//
//  main.m
//  代理学习
//
//  Created by 张文艺 on 2021/11/12.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    
    int a = 4;
    
    switch (a) {
        case 1:
            NSLog(@"1");
            break;
        case 2:
            NSLog(@"2");
            break;
        case 3:
            NSLog(@"3");
            break;
        case 4:
        case 5:
            NSLog(@"5");
            break;
        default:
            break;
    }
    
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
