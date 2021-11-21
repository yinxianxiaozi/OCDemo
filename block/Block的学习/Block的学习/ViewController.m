//
//  ViewController.m
//  Block的学习
//
//  Created by 张文艺 on 2021/11/5.
//

#import "ViewController.h"
#import "WYBlock.h"
#import "WYBlock.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self blockTest];
//    [self blockTest2];
//    [self blockTest3];
//    [self blockTest4];
//    [self test];
    WYBlock *block = [[WYBlock alloc] init];
//    [block testVariable];
//    [block blockType];
//    [block circularTest];
//    [block circularTest5];
    [block circularTest6];
    // Do any additional setup after loading the view.
}


//block的定义和调用
- (void)blockTest{
    
    //1:定义block
    //返回值类型 (^block的变量名）（参数类型)
    //2:申请空间
    //^返回值类型(参数列表)
    void (^testBlock)(int num1,int num2) = ^void(int num1,int num2){
        NSLog(@"num1+num2=%d",num1+num2);
    };

    addBlock2 block2= ^void(int num1,int num2){
        NSLog(@"num1+num2=%d",num1+num2);
    };
    
    //3:调用
    testBlock(1,2);
    block2(3,4);
}

//block的参数传递
/*
 1、传递block的实现
 2、在被调用的方法里调用block
 */
- (void)blockTest2{
    WYBlock *block = [[WYBlock alloc] init];
    [block sumWithblock:^int(int num1, int num2) {
        NSLog(@"num1*num2:%d",num1*num2);
        return num1*num2;
    }];
    
    [block sumWithblock2:^int(int num1, int num2) {
        return num1+num2;
    }];
}

//block作为返回值
- (addBlock2)blockTest3{
    return ^void(int num1,int num2){
        NSLog(@"num1+num2=%d",num1+num2);
    };
}

- (void)test{
   addBlock2 block = [self blockTest3];
    block(10,10);
}

//block作为属性
- (void)blockTest4{
    WYBlock *block = [[WYBlock alloc] init];
    
    //定义
    block.block1 = ^int(int num1, int num2) {
        NSLog(@"num1+num2=%d",num1+num2);
        return num1+num2;
    };
    block.myBlock2 = ^(int num1, int num2) {
        NSLog(@"num1*num2=%d",num1*num2);
    };
    
    //调用
    block.block1(1, 2);
    block.myBlock2(3, 5);
}


@end
