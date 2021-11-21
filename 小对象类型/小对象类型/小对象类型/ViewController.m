//
//  ViewController.m
//  小对象类型
//
//  Created by 张文艺 on 2021/11/10.
//

#import "ViewController.h"
#import <objc/runtime.h>

@interface ViewController ()

@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, strong) NSString *nameStr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self taggedPointerDemo];
//    [self test];
//    [self testNSString];
//    [self getTaggedPointer];
    [self getTaggedPointer2];
    // Do any additional setup after loading the view.
}


//面试题
//*********代码1*********
- (void)taggedPointerDemo {
  self.queue = dispatch_queue_create("wy", DISPATCH_QUEUE_CONCURRENT);
    
    for (int i = 0; i<20000; i++) {
        dispatch_async(self.queue, ^{
            self.nameStr = [NSString stringWithFormat:@"wy"];  // alloc 堆 iOS优化 - taggedpointer
             NSLog(@"%@",self.nameStr);
        });
    }
}

//*********代码2*********

- (void)test {
    self.queue = dispatch_queue_create("wy", DISPATCH_QUEUE_CONCURRENT);
    for (int i = 0; i<20000; i++) {
        dispatch_async(self.queue, ^{
            self.nameStr = [NSString stringWithFormat:@"wy的家福克斯的附近看到的数据开发机即可的房间奥施康定加法可的假发"];
            NSLog(@"%@",self.nameStr);
        });
    }
}


#define KLog(_c) NSLog(@"%@ -- %p -- %@",_c,_c,[_c class]);

- (void)testNSString{
    //初始化方式一：通过 WithString + @""方式
    //这种是常量类型
    //事实上，WithString就等同于直接赋值，没有区别，所以苹果建议直接使用字符串赋值
    NSString *s1 = @"1";
    NSString *s2 = [[NSString alloc] initWithString:@"222"];
    NSString *s3 = [NSString stringWithString:@"33"];
    NSString *s22 = @"fjkdfjkdajfadkfjadlk;fj看对方金阿奎射流风机安抚巾";
    
    KLog(s1);
    KLog(s2);
    KLog(s3);
    KLog(s22);
    
    //初始化方式二：通过 WithFormat，且字符串长度在9以内
    //这种是小对象类型
    NSString *s4 = [NSString stringWithFormat:@"123456789"];
    NSString *s5 = [[NSString alloc] initWithFormat:@"123456789"];
    KLog(s4);
    KLog(s5);
    
    //初始化方式二：通过 WithFormat，且字符串长度大于9
    //这种是引用类型
    NSString *s6 = [NSString stringWithFormat:@"1234567890"];
    NSString *s7 = [[NSString alloc] initWithFormat:@"1234567890"];
    KLog(s6);
    KLog(s7);
}

extern uintptr_t objc_debug_taggedpointer_obfuscator;

//解码
static inline uintptr_t
_objc_decodeTaggedPointer(const void * _Nullable ptr)
{
    return (uintptr_t)ptr ^ objc_debug_taggedpointer_obfuscator;
}

- (void)getTaggedPointer{
    NSString *str1 = [NSString stringWithFormat:@"a"];
    NSString *str2 = [NSString stringWithFormat:@"b"];
    NSString *str3 = [NSString stringWithFormat:@"ab"];
    NSLog(@"str1：%p-- %@ -- %@",str1,str1,str1.class);
    NSLog(@"str2：%p-- %@ -- %@",str2,str2,str1.class);
    NSLog(@"str3：%p-- %@ -- %@",str3,str3,str1.class);
    
    NSLog(@"str1：0x%lx",_objc_decodeTaggedPointer(CFBridgingRetain(str1)));
    NSLog(@"str2：0x%lx",_objc_decodeTaggedPointer(CFBridgingRetain(str2)));
    NSLog(@"str2：0x%lx",_objc_decodeTaggedPointer(CFBridgingRetain(str2)));
}


- (void)getTaggedPointer2{
    NSNumber *number1 = @1;
    NSNumber *number2 = @(-1); // 0xbffffffffffffff2
    NSNumber *number3 = @2.0;
    NSNumber *number4 = @3.2;
    NSLog(@"%@-%p-%@",object_getClass(number1),number1,number1);
    NSLog(@"%@-%p-%@",object_getClass(number2),number2,number2);
    NSLog(@"%@-%p-%@",object_getClass(number3),number3,number3);
    NSLog(@"%@-%p-%@",object_getClass(number4),number4,number4);

    NSLog(@"%@-%p-%@ - 0x%lx",object_getClass(number1),number1,number1,_objc_decodeTaggedPointer((__bridge const void * _Nullable)(number1)));
    NSLog(@"0x%lx",_objc_decodeTaggedPointer_(number2)); // 0xb000000000000012
    NSLog(@"0x%lx",_objc_decodeTaggedPointer_(CFBridgingRetain(number3)));
    NSLog(@"0x%lx",_objc_decodeTaggedPointer(CFBridgingRetain(number4)));
}

@end
