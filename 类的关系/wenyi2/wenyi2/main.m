//
//  main.m
//  wenyi2
//
//  Created by 张文艺 on 2021/7/19.
//

#import <Foundation/Foundation.h>
#import "WYPerson.h"
#import "MyAssertHandler.h"

void assertTest(){
    NSLog(@"Hello, World!");
    //断言
        WYPerson *p = [[WYPerson alloc] init];

        //添加到线程中
        NSAssertionHandler *myHandle = [[MyAssertHandler alloc] init];
        [[[NSThread currentThread] threadDictionary] setValue:myHandle forKey:NSAssertionHandlerKey];

        [p eat];
        [p drink:nil];
    
}

void isKindOfClassTest(){
    //-----使用 iskindOfClass & isMemberOfClass 类方法
    /*
     结果：1000
     */
    BOOL re1 = [(id)[NSObject class] isKindOfClass:[NSObject class]];       //
    BOOL re2 = [(id)[NSObject class] isMemberOfClass:[NSObject class]];     //
    BOOL re3 = [(id)[WYPerson class] isKindOfClass:[WYPerson class]];       //
    BOOL re4 = [(id)[WYPerson class] isMemberOfClass:[WYPerson class]];     //
    NSLog(@" re1 :%hhd\n re2 :%hhd\n re3 :%hhd\n re4 :%hhd\n",re1,re2,re3,re4);
    
    

    //------iskindOfClass & isMemberOfClass 实例方法
    /*
     结果：1111
     */
    BOOL re5 = [(id)[NSObject alloc] isKindOfClass:[NSObject class]];       //
    BOOL re6 = [(id)[NSObject alloc] isMemberOfClass:[NSObject class]];     //
    BOOL re7 = [(id)[WYPerson alloc] isKindOfClass:[WYPerson class]];       //
    BOOL re8 = [(id)[WYPerson alloc] isMemberOfClass:[WYPerson class]];     //
    NSLog(@" re5 :%hhd\n re6 :%hhd\n re7 :%hhd\n re8 :%hhd\n",re5,re6,re7,re8);
}

void forTest(){
    for (int i=0; i<10; i++) {
        NSLog(@"i=%d",i);
        if (i==3) {
            break;
        }
    }
    
    /*
     前提说明：
        a语句：int i=0;
        b语句：i<10;
        c语句：i++
        d语句：NSLog(@"i=%d",i);
     执行顺序：
        1、执行a语句
        2、执行b语句
        3、执行d语句
        4、循环执行，直到i<10(顺序执行C语句、b语句、d语句）
        5、i<10，退出循环
     */
}

void jibenTest(){
    int a = 8,b=4,c=0;
    c = a - b++;//先减后加
    c = a - ++b;//先加后减
    NSLog(@"c=%d",c);
}

void stringTest(){
    NSString *str1 = @"zwy";
    NSString *str2 = @"复健科发电机房开发就按肯德基发放卡夫卡的房间";
    
    NSString *str3 = [NSString stringWithString:@"zwy2"];
    NSString *str4 = [[NSString alloc] initWithString:@"复健科发电机房开发就按肯德基发放卡夫卡的房间"];
    
    NSLog(str1);
    NSLog(str2);
    NSLog(str3);
    NSLog(str4);
    
    //初始化方式二：通过 WithFormat
    //字符串长度在9以内
    NSString *s4 = [NSString stringWithFormat:@"123456789"];
    NSString *s5 = [[NSString alloc] initWithFormat:@"123456789"];
    
    //字符串长度大于9
    NSString *s6 = [NSString stringWithFormat:@"1234567890"];
    NSString *s7 = [[NSString alloc] initWithFormat:@"1234567890"];
    
    NSLog(s4);
    NSLog(s5);
    NSLog(s6);
    NSLog(s7);
}

void classTest(){
    WYPerson *p = [[WYPerson alloc] init];
    //这里说明返回的是同一个对象，class类方法返回的是自己
    NSLog(@"对象Class--%@ -- %p",[p class],[p class]);
    NSLog(@"类Class--%@ -- %p",[WYPerson class],[WYPerson class]);
}

void testPointer(BOOL * isS){
//    BOOL a = YES;
//    isS = &a;
//
    BOOL b = NO;
    *isS = b;
    NSLog(@"wenyi-%p -- %s -- %d",isS,isS,*isS);
}


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
//        NSArray *array = [[NSArray alloc] init];
//        for (int i=0; array.count; i++) {
//            NSLog(@"kaishi");
//        }
//        BOOL isSuccess = YES;
//        BOOL *isSuccessPointer = &isSuccess;
//        //查询结果是否成功，默认成功，因为不查询自定义组织也认为是查询成功
////
////        testPointer(isSuccessPointer);
////        if (isSuccessPointer) {
////            isSuccess = *isSuccessPointer;
////        }
////        NSLog(@"isSucess--%d",isSuccess);
//        NSLog(@"isSucess111--%d--%p -- %s -- %d",*isSuccessPointer,isSuccessPointer,isSuccessPointer,isSuccess);
//        testPointer(isSuccessPointer);
//        NSLog(@"isSucess--%d--%p -- %s -- %d",*isSuccessPointer,isSuccessPointer,isSuccessPointer,isSuccess);
        
        NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
        NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
        [dic1 setValue:@"a" forKey:@"1"];
        [dic1 setValue:@"b" forKey:@"2"];
        [dic2 setValue:@"aa" forKey:@"1"];
        [dic1 addEntriesFromDictionary:dic2];
    }
    return 0;
}


