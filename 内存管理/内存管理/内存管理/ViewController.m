//
//  ViewController.m
//  内存管理
//
//  Created by 张文艺 on 2021/11/9.
//

#import "ViewController.h"

int quanju;

@interface ViewController ()

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
//    [self test];
    [self test2];
    // Do any additional setup after loading the view.
}

- (void)test2{
    NSLog(@"%ld",CFGetRetainCount((__bridge CFTypeRef)[NSObject alloc]));
}

- (void)test{
    //栈
    NSInteger i = 123;
    NSLog(@"i的内存地址：%p", &i);
    
    //堆
    NSObject *obj = [[NSObject alloc] init];
    NSLog(@"obj的内存地址：%p", obj);
    NSLog(@"&obj的内存地址：%p", &obj);
    
    //静态
    static NSInteger jingtai = 111;
    NSLog(@"jingtai的内存地址：%p", &jingtai);
    
    //全局区
    quanju = 222;
    NSLog(@"quanju的内存地址：%p", &quanju);
    
    //常量池
    NSString *string = @"CJL";
    NSLog(@"string的内存地址：%p", string);
    NSLog(@"&string的内存地址：%p", &string);
}

@end
