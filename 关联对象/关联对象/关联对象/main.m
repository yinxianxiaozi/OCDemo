//
//  main.m
//  关联对象
//
//  Created by 张文艺 on 2021/10/19.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "WYPerson.h"
#import "WYPerson+cate.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        
        WYPerson *person = [WYPerson alloc];
        person.cate_name = @"嘿嘿";
        
        NSLog(@"移除关联前%@",person.cate_name);
        //移除关联对象
        [person removeAssociation];
        NSLog(@"移除关联后%@",person.cate_name);
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
