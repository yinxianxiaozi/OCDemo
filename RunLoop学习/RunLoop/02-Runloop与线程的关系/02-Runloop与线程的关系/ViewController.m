//
//  ViewController.m
//  02-Runloop与线程的关系
//
//  Created by cooci on 2018/12/5.
//  Copyright © 2018 cooci. All rights reserved.
//

#import "ViewController.h"
#import "LGThread.h"

@interface ViewController ()
@property (nonatomic, assign) BOOL isStopping;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // runloop 和 线程
    // 主运行循环
     CFRunLoopRef mainRunloop = CFRunLoopGetMain();
     // 当前运行循环
     CFRunLoopRef currentRunloop = CFRunLoopGetCurrent();

    // 子线程runloop 默认不启动
    
    self.isStopping = NO;
    LGThread *thread = [[LGThread alloc] initWithBlock:^{
        NSLog(@"%@---%@",[NSThread currentThread],[[NSThread currentThread] name]);
        //通过控制变量isStopping可以停止当前线程，线程停止，RunLoop也就结束，RunLoop结束NSTimer也就停止了
        [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            NSLog(@"hello word");            // 退出线程--结果runloop也停止了
            if (self.isStopping) {
                [NSThread exit];
            }
        }];
         [[NSRunLoop currentRunLoop] run];
    }];
    thread.name = @"wy.com";
    [thread start];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.isStopping = YES;
}





@end
