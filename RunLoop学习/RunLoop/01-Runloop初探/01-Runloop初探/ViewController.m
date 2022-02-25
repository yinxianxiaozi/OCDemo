//
//  ViewController.m
//  01-Runloop初探
//
//  Created by cooci on 2018/12/4.
//  Copyright © 2018 cooci. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@end

@implementation ViewController


+ (void)load{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotNotification:) name:@"helloMyNotification" object:nil];
    
    [self sourceDemo];
}

- (void)sourceDemo{
    
    //__CFRUNLOOP_IS_CALLING_OUT_TO_A_TIMER_CALLBACK_FUNCTION__
//    [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        NSLog(@"wy:NSTimer");
//    }];
//    [self performSelector:@selector(fire) withObject:nil afterDelay:1.0];
    
    // __CFRUNLOOP_IS_SERVICING_THE_MAIN_DISPATCH_QUEUE__
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"wy:mainQueue");
    });
    
    // __CFRUNLOOP_IS_CALLING_OUT_TO_A_BLOCK__
    void (^block)(void) = ^{
        NSLog(@"wy:block");
    };
    
    block();
}

// __CFRUNLOOP_IS_CALLING_OUT_TO_A_TIMER_CALLBACK_FUNCTION__
- (void)fire{
    NSLog(@"performSeletor");
}

#pragma mark - 触摸事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    // __CFRUNLOOP_IS_CALLING_OUT_TO_A_SOURCE0_PERFORM_FUNCTION__
//    NSLog(@"wy:事件");
     [[NSNotificationCenter defaultCenter] postNotificationName:@"helloMyNotification" object:@"cooci"];

}
- (void)gotNotification:(NSNotification *)noti{
    // __CFNOTIFICATIONCENTER_IS_CALLING_OUT_TO_AN_OBSERVER__
     NSLog(@"wy:observer---gotNotification = %@",noti);
}



@end
