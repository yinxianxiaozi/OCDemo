//
//  ViewController.m
//  多线程使用
//
//  Created by 张文艺 on 2021/10/24.
//

#import "ViewController.h"
#import "GCDTest.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self wy_createNSThreadTest];
    // Do any additional setup after loading the view.
    GCDTest *gcd = [GCDTest alloc];
//    [gcd mainSyncTest];
//    [gcd mainAsyncTest];
//    [gcd globalAsyncTest];
//    [gcd globalSyncTest];
//    [gcd textDemo2];
//    [gcd textDemo1];
    [gcd textDemo];
//    [gcd concurrentSyncTest];
//    [gcd concurrentAsyncTest];
//    [gcd serialAsyncTest];
//    [gcd serialSyncTest];
//    [gcd cjl_testGroup2];
//    [gcd cjl_testBarrier];
//    [gcd cjl_testSemaphore];
}

//1、创建
- (void)wy_createNSThreadTest{
    NSString *threadName1 = @"NSThread1";
    NSString *threadName2 = @"NSThread2";
    NSString *threadName3 = @"NSThread3";
    NSString *threadNameMain = @"NSThreadMain";
    
    //方式一：初始化方式，需要手动启动
    NSThread *thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(doSomething:) object:threadName1];
    thread1.name = @"thread1";
    [thread1 start];
    
    //方式二：构造器方式，自动启动
    [NSThread detachNewThreadSelector:@selector(doSomething:) toTarget:self withObject:threadName2];
    
    //方式三：performSelector...方法创建子线程
    [self performSelectorInBackground:@selector(doSomething:) withObject:threadName3];
    
    //方式四:performSelector...方法创建主线程
    [self performSelectorOnMainThread:@selector(doSomething:) withObject:threadNameMain waitUntilDone:YES];
    
}
- (void)doSomething:(NSObject *)objc{
    NSLog(@"%@ - %@", objc, [NSThread currentThread]);
}

- (void)wy_NSThreadClassMethod{
    //当前线程
    [NSThread currentThread];
    // 如果number=1，则表示在主线程，否则是子线程
    NSLog(@"%@", [NSThread currentThread]);
    
    //阻塞休眠
    [NSThread sleepForTimeInterval:2];//休眠多久
    [NSThread sleepUntilDate:[NSDate date]];//休眠到指定时间
    
    //其他
    [NSThread exit];//退出线程
    [NSThread isMainThread];//判断当前线程是否为主线程
    [NSThread isMultiThreaded];//判断当前线程是否是多线程
    NSThread *mainThread = [NSThread mainThread];//主线程的对象
    NSLog(@"%@", mainThread);
}
@end
