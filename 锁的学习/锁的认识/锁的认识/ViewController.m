//
//  ViewController.m
//  锁的认识
//
//  Created by 张文艺 on 2021/11/6.
//

#import "ViewController.h"
#import "WYPerson.h"
#import <objc/runtime.h>

@interface ViewController ()
@property (nonatomic,strong) WYPerson *person;
@property (nonatomic, assign) NSUInteger ticketCount;
@property (nonatomic, strong) NSCondition *testCondition;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ticketCount = 0;
    self.person = [[WYPerson alloc] init];
//    [self synchronizedTest];
//    [self lockTest];
//    [self recursiveLockTest];
//    [self conditionLockTest];
    [self conditionTest];
    // Do any additional setup after loading the view.
}


- (void)synchronizedTest{
    for (int i=0; i<200000; i++) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            @synchronized (self) {
                self.person = [[WYPerson alloc] init];
                NSLog(@"wenyi-%d",i);
//            }
        });
        
    }
}

//这里采用递归的block
- (void)lockTest{
    NSLock *lock = [[NSLock alloc] init];
    for (int i= 0; i<100; i++) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            static void (^testMethod)(int);
            testMethod = ^(int value){
                [lock lock];
                if (value > 0) {
                  NSLog(@"current value = %d",value);
                  testMethod(value - 1);
                }
            };
            testMethod(10);
            [lock unlock];
        });
    }

}

- (void)recursiveLockTest{
    NSRecursiveLock *lock = [[NSRecursiveLock alloc] init];
    for (int i= 0; i<100; i++) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            static void (^testMethod)(int);
            testMethod = ^(int value){
                [lock lock];
                if (value > 0) {
                  NSLog(@"current value = %d",value);
                  testMethod(value - 1);
                }
            };
            testMethod(10);
            [lock unlock];
        });
    }

}

/*
 条件锁，通过条件判断来决定是否可以加锁。
 */
- (void)conditionLockTest{

    //初始化状态为2
    NSConditionLock *conditionLock = [[NSConditionLock alloc] initWithCondition:2];
    
    /*
     条件为1时执行加锁，并且解锁时将条件设置为0
     */
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
         [conditionLock lockWhenCondition:1]; // conditoion = 1 内部 Condition 匹配
        NSLog(@"线程 1");
         [conditionLock unlockWithCondition:0]; // 解锁并把conditoion设置为0
    });
    
    /*
     条件为2时可执行加锁，并且解锁时将条件设置为1
     */
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
       
        [conditionLock lockWhenCondition:2]; // conditoion = 2 内部 Condition 匹配
        sleep(0.1);
        NSLog(@"线程 2");
        [conditionLock unlockWithCondition:1]; // 解锁并把conditoion设置为1
    });
    
    /*
     就是普通的锁，不加任何条件,任何时候都可能来
     */
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        sleep(2);
       [conditionLock lock];
       NSLog(@"线程 3");
       [conditionLock unlock];
    });
}

//条件锁实现生产消费者模式
- (void)conditionTest{
    
    _testCondition = [[NSCondition alloc] init];
    
    //创建生产-消费者
    for (int i = 0; i < 50; i++) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [self producer]; // 生产者
        });
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [self consumer]; // 消费者
        });
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [self consumer]; // 消费者
        });
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [self producer]; // 生产者
        });
    }
}

- (void)producer{
    [_testCondition lock]; // 操作的多线程影响
    self.ticketCount = self.ticketCount + 1;
    NSLog(@"生产一个 现有 count %zd",self.ticketCount);
    [_testCondition signal]; // 发送信号
    [_testCondition unlock];
}

- (void)consumer{
 
     [_testCondition lock];  // 操作的多线程影响
    if (self.ticketCount == 0) {
        NSLog(@"等待 count %zd",self.ticketCount);
        [_testCondition wait]; // 线程等待
    }
    //注意消费行为，要在等待条件判断之后
    self.ticketCount -= 1;
    NSLog(@"消费一个 还剩 count %zd ",self.ticketCount);
     [_testCondition unlock];
}


@end
