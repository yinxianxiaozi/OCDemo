//
//  ViewController.m
//  拷贝的学习
//
//  Created by 张文艺 on 2021/11/26.
//

#import "ViewController.h"
#import "WYPerson.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [self customClassTest];
//    WYPerson *person = [WYPerson alloc];
//    NSLog(@"copy:%@",[person copy]);
//    NSLog(@"mutable:%@",[person mutableCopy]);
//
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#define WYLog(_str,_c) NSLog(@"%@：%@ -- %p -- %@",_str,_c,_c,[_c class]);

//系统类的调用
- (void)customClassTest{
    NSString *str1 = [NSString stringWithFormat:@"巴拉啦小魔仙~"];
    WYLog(@"初始", str1);
    /*
     1、copy：非集合类
     */
    {
        WYLog(@"copy结果", str1.copy);
        WYLog(@"mutableCopy结果", str1.mutableCopy);
        NSMutableString *str2 = [[NSMutableString alloc] initWithString:str1];
    }
    
    /*
     2、mutableCopy：非集合类
     */
    {
        
    }
    
    /*
     3、copy：集合类
     */
    {
        
    }
    
    /*
     4、mutableCopy：集合类
     */
    {
        
    }
    
}

//自定义类的调用





@end
