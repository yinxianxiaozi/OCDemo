//
//  main.m
//  内存对齐原理
//
//  Created by 张文艺 on 2021/10/13.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <malloc/malloc.h>

struct struct1 {
    char a;     //1字节
    double b;   //8字节
    int c;      //4字节
    short d;    //2字节
}struct1;

struct struct2 {
    double b;   //8字节
    int c;      //4字节
    short d;    //2字节
    char a;     //1字节
    
}struct2;

struct struct3 {
    double b;   //8字节
    char a;     //1字节
    int c;      //4字节
    short d;    //2字节
    
}struct3;



struct Mystruct4 {
    int a;
    struct Mystruct5 {
        double b;
        short c;
    }struct5;
}struct4;

struct Mystruct6 {
    char b;
    int c;
    short d;
}struct6;

struct Mystruct7 {
    int c;
    double a;
    char b;
    struct Mystruct6 struct6;
    short d;
}struct7;

void neicunduiqi() {
    NSLog(@"struct1=%lu,struct2=%lu,struct3=%lu",sizeof(struct1),sizeof(struct2),sizeof(struct3));
    /*
     2021-05-21 21:49:42.707254+0800 Wenyi[48257:2788563] struct1=24,struct2=16,struct3=24
     */
    
    NSLog(@"struct4:%lu,struct7:%lu",sizeof(struct4),sizeof(struct7));
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        neicunduiqi();
        NSObject *objc = [[NSObject alloc] init];
        NSLog(@"objc对象类型占用的内存大小：%lu",sizeof(objc));
        NSLog(@"objc对象实际占用的内存大小：%lu",class_getInstanceSize([objc class]));
        NSLog(@"objc对象实际分配的内存大小：%lu",malloc_size((__bridge const void*)(objc)));
    }
    return 0;
}

