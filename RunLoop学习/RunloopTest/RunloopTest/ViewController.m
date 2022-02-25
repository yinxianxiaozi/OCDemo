//
//  ViewController.m
//  RunloopTest
//
//  Created by 张文艺 on 2021/11/27.
//

#import "ViewController.h"

@interface ViewController ()
@property(nonatomic,strong)NSThread *thread;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self nestTest];
    // Do any additional setup after loading the view.
}

- (IBAction)clickTest:(id)sender {
       // 创建子线程并开启
        NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(show) object:nil];
        thread.name = @"wyThread";
        self.thread = thread;
        [self.thread start];
}

//在子线程中增加一个RunLoop
-(void)show
{
    // 注意：打印方法一定要在RunLoop创建开始运行之前，如果在RunLoop跑起来之后打印，RunLoop先运行起来，已经在跑圈了就出不来了，进入死循环也就无法执行后面的操作了。
    // 但是此时点击Button还是有操作的，因为Button是在RunLoop跑起来之后加入到子线程的，当Button加入到子线程RunLoop就会跑起来
    NSLog(@"%s",__func__);
    // 1.创建子线程相关的RunLoop，在子线程中创建即可，并且RunLoop中要至少有一个Timer 或 一个Source 保证RunLoop不会因为空转而退出，因此在创建的时候直接加入
    
    
    // 添加Source [NSMachPort port] 添加一个端口
    [[NSRunLoop currentRunLoop] addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
    
    // 添加一个Timer
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(test) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
    //创建监听者
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        switch (activity) {
            case kCFRunLoopEntry:
                NSLog(@"RunLoop进入");
                break;
            case kCFRunLoopBeforeTimers:
                NSLog(@"RunLoop要处理Timers了");
                break;
            case kCFRunLoopBeforeSources:
                NSLog(@"RunLoop要处理Sources了");
                break;
            case kCFRunLoopBeforeWaiting:
                NSLog(@"RunLoop要睡眠了");
                break;
            case kCFRunLoopAfterWaiting:
                NSLog(@"RunLoop被唤醒了");
                break;
            case kCFRunLoopExit:
                NSLog(@"RunLoop退出了");
                break;

            default:
                break;
        }
    });
    // 给RunLoop添加监听者
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);//这里并不是创建RunLoop，只是把当前的RunLoop放到这个线程中
    
    // 2.子线程需要开启RunLoop
    [[NSRunLoop currentRunLoop] run];//run用来开启RunLoop
    CFRelease(observer);
}

- (IBAction)closeRunLoopClick:(id)sender {
//    if (![NSThread isMainThread]) {
        [NSThread exit];
//    }
}


-(void)test
{
    NSLog(@"%@",[NSThread currentThread]);
}

#define WYLog(str,_rl,_rlm) NSLog(@"%@:%@ - %@",str,_rl,_rlm);

/**
 runloop嵌套测试，
 */
- (void)nestTest {
    //异步并发，开启了子线程，将NSTImer添加到了子线程中
    WYLog(@"主线程",[NSThread currentThread],[[NSRunLoop currentRunLoop] currentMode]);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        WYLog(@"进入子线程的第一层mode",[NSThread currentThread],[[NSRunLoop currentRunLoop] currentMode]);
        //添加NSTimer
        NSTimer *tickTimer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:1 target:self selector:@selector(timerHandle1) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:tickTimer forMode:NSDefaultRunLoopMode];
        
        //启动DefaultMode的Runloop
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode  beforeDate:[NSDate dateWithTimeIntervalSinceNow:2]];
        WYLog(@"结束子线程的第一层mode",[NSThread currentThread],[[NSRunLoop currentRunLoop] currentMode]);
        
    });
    
}

/**
 不停的运行与退出最内层runloop
 */
- (void)timerHandle1 {
    WYLog(@"开始进入第二层",[NSThread currentThread],[[NSRunLoop currentRunLoop] currentMode]);
    // 防止多次添加timer，开发中应特别注意
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSTimer *tickTimer2 = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:1 target:self selector:@selector(timerHandle2) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:tickTimer2 forMode:UITrackingRunLoopMode];
    });
    [[NSRunLoop currentRunLoop] runMode:UITrackingRunLoopMode  beforeDate:[NSDate distantFuture]];
    //在timerHandle2中已将第二层的mode关闭掉，所以这里只是第一层mode了，这里并不是新建的mode，而是原来的mode
    WYLog(@"子线程的第一层Mode",[NSThread currentThread],[[NSRunLoop currentRunLoop] currentMode]);
}

//tickTimer2添加到了UITrackingRunLoopMode中，所以这里获取到的mode是UITrackingRunLoopMode
- (void)timerHandle2 {
    CFRunLoopStop([[NSRunLoop currentRunLoop] getCFRunLoop]);
    //虽然上面已经关闭掉，但是这个函数还没执行完，所以这里还是可以获取当前的mode，执行完这个函数才真正的关闭掉
    WYLog(@"结束子线程的第二层Mode",[NSThread currentThread],[[NSRunLoop currentRunLoop] currentMode]);
}



@end
