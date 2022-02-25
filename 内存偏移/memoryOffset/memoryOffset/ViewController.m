//
//  ViewController.m
//  memoryOffset
//
//  Created by 张文艺 on 2021/7/17.
//

#import "ViewController.h"
#import "NSPerson.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //1、基本数据类型
    /*
     a为变量，是值的抽象概念
     &a是得到变量a的地址
     f是存储地址的指针变量，它是指针类型
     *f是得到指针变量f上的地址所指向的变量值
     */
    int a = 10;
    int b = 10;
    int *f = &a;
    int *g = f-1;
//
//    NSLog(@"基本数据类型的变量a:%d --变量地址:%p",a,&a);
//    NSLog(@"基本数据类型的变量b:%d --变量地址:%p",b,&b);
//    NSLog(@"基本数据类型的指针a:%p --指针b:%p",f,f-1);
//    NSLog(@"指针变量f所指向的a变量的内容:%d --变量b的内容:%d",*f,*(f-1));
//    NSLog(@"指针变量f所在的内存地址：%p",&f);
    
    
    //引用类型
    NSPerson *person1 = [NSPerson alloc];
    NSPerson *person2 = [NSPerson alloc];
//    NSLog(@"引用类型的指针person1:%@ --变量地址:%p",person1,&person1);
//    NSLog(@"引用类型的指针person2:%@ --变量地址:%p",person2,&person2);
    
    /*
     2021-07-17 21:12:31.884500+0800 memoryOffset[3720:843752] 引用类型的指针person1:<NSPerson: 0x6000010a0570> --变量地址:0x106290f90
     2021-07-17 21:12:31.884616+0800 memoryOffset[3720:843752] 引用类型的指针person2:<NSPerson: 0x6000010a0580> --变量地址:0x106290f88
     */
    //数组指针
    int c[4] = {1,2,3,4};
    int *d = c;
    NSLog(@"数组所在地址：%p -- 数组首元素地址：%p - 数组第二元素地址：%p", &c, &c[0], &c[1]);
    NSLog(@"数组所在地址%p -- 数组第二元素地址%p - 数组第三元素地址%p", d, d+1, d+2);
    NSLog(@"数组第一个元素%d -- 数组第二元素%d - 数组第三元素%d", *d, *(d+1), *(d+2));
    
    
    /*
     2021-07-17 21:35:48.606554+0800 memoryOffset[4341:863420] 数组所在地址：0x10cce4fe0 -- 数组首元素地址：0x10cce4fe0 - 数组第二元素地址：0x10cce4fe4
     2021-07-17 21:35:48.606662+0800 memoryOffset[4341:863420] 数组所在地址0x10cce4fe0 -- 数组第二元素地址0x10cce4fe4 - 数组第三元素地址0x10cce4fe8
     2021-07-17 21:35:48.606725+0800 memoryOffset[4341:863420] 数组第一个元素1 -- 数组第二元素2 - 数组第三元素3
     */
    
    
    
    
    // Do any additional setup after loading the view.
}


@end
