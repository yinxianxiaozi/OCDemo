//
//  WYBlock.m
//  Block的学习
//
//  Created by 张文艺 on 2021/11/7.
//

#import "WYBlock.h"
#import "WYProxy.h"

int quanju = 10;

@interface WYBlock ()
{
    NSString *string;
}

@end

@implementation WYBlock
//block作为参数，提前定义好block
- (void)sumWithblock:(myBlock) block{
    NSLog(@"block的结果是%d",block(3,5));
}

//临时定义block
- (void)sumWithblock2:(int (^)(int num1,int num2)) block{
    NSLog(@"block2的结果是%d",block(3,5));
}

//没有返回值的临时定义block
- (void)sumWithblock3:(void (^)(int num1,int num2)) block{
    block(3,5);
}

//block捕获变量的测试
- (void)testVariable{

    __block int a = 10;
    __block NSString *str = [[NSString alloc] init];
    str = @"wy11";
    NSLog(@"a1---%d---%p",a,&a);
    NSLog(@"str1--%@--%p",str,str);
    a = 100;
    NSLog(@"a2---%d---%p",a,&a);
    NSLog(@"str2--%@--%p",str,str);
    void (^block)(void) = ^{
        a = a+1;
        str = @"wy22";
        NSLog(@"a3--%d--%p",a,&a);
        NSLog(@"str3--%@--%p",str,str);
    };
    block();
    NSLog(@"a4--%d---%p",a,&a);
    NSLog(@"str4--%@--%p",str,str);
}

//block类型获取
- (void)blockType{
    //全局block
    {
        //不使用任何数据
        void (^globalBlock1)(void) = ^{
            NSLog(@"quanju:%d",quanju);
        };
        NSLog(@"wy:globalBlock1--%@",globalBlock1);
        //使用全局变量
        void (^globalBlock2)(void) = ^{
            NSLog(@"wy");
        };
        NSLog(@"wy:globalBlock2--%@",globalBlock2);
    
    }
    
    //堆block
    {
        void (^mallocBlock1)(void) = ^{
            self->string = @"wy";
        };
        
        NSLog(@"wy:mallocBlock1--%@",mallocBlock1);
        int a;
        void (^mallocBlock2)(void) = ^{
            NSLog(@"a=%d",a);
        };
        NSLog(@"wy:mallocBlock2--%@",mallocBlock2);
    }
    
    //栈block
    {
        int b = 10;
        void (^ __weak stackBlock1)(void) = ^{
            NSLog(@"b=%d",b);
        };
        NSLog(@"wy:stackBlock1--%@",stackBlock1);
    }
    
}


/*
 不会出现循环引用
 虽然block使用了self，但是这个block并没有被self持有，所以不会出现
 */

- (void)circularTest{
    [self sumWithblock:^int(int num1, int num2) {
        self.name = @"zhang";
        return num1+num2;
    }];
}

/*
 会出现循环引用
 在block内部使用self会出现循环引用，因为self和block相互引用
 */
- (void)circularTest2{
    self.block1 = ^int(int num1, int num2) {
        self.name = @"zhang";
        return num1+num2;
    };
    self.block1(10,2);
}

/*
 循环引用解决1: __weak弱引用self
 将block持有self这一环断开
 */
- (void)circularTest3{
    __weak typeof(self) weakSelf = self;
    self.block1 = ^int(int num1, int num2) {
        weakSelf.name = @"zhang";
        return num1+num2;
    };
    self.block1(10,2);
}
/*
 循环引用解决2：在block内将对象设置为nil
 通过wyBlock作为中介，给self增加一个引用，之后将wyBlock设置为nil就可以给self减少一个引用计数了
 */

- (void)circularTest4{
    __block WYBlock *wyBlock = self;
    self.block1 = ^int(int num1, int num2) {
        wyBlock.name = @"zhang";
        wyBlock = nil;
        return num1+num2;
    };
    self.block1(10,2);
}

/*
 循环引用解决3：对象self作为参数
 wyBlock的生命周期仅在block内部，与self无关。block不持有self
 */
- (void)circularTest5{
    self.block11 = ^(WYBlock *wyBlock){
        wyBlock.name = @"wy";
        NSLog(@"wy--%@",wyBlock.name);
    };
    self.block11(self);
}

/*
 循环引用解决4：通过虚基类调用方法，不与self绑定
 */
- (void)circularTest6{
    WYProxy *proxy = [WYProxy alloc];
    [proxy transformObjc:self];
    self.block1 = ^int(int num1, int num2) {
        [proxy performSelector:@selector(eat)];
        return num1+num2;
    };
    self.block1(10,2);
}

- (void)eat{
    NSLog(@"eat");
}


@end
