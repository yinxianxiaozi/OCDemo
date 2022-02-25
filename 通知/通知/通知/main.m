//
//  main.m
//  通知
//
//  Created by 张文艺 on 2021/11/23.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "NSPerson.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
