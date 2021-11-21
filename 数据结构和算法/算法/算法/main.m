//
//  main.m
//  算法
//
//  Created by 张文艺 on 2021/10/31.
//

#import <Foundation/Foundation.h>
//使用中间变量
void swap1(int a,int b){
    int tmp = a;
    a = b;
    b = tmp;
    
    NSLog(@"a:%d,b:%d",a,b);
}

//加法
void swap2(int a,int b){
    a = a + b;
    b = a - b;
    a = a - b;
    NSLog(@"a:%d,b:%d",a,b);
}

//异或
void swap3(int a,int b){
    a = a ^ b;
    b = a ^ b;
    a = a ^ b;
    NSLog(@"a:%d,b:%d",a,b);
}


//求最大公约数
//直接遍历法
int maxCommonDivisor(int a,int b){
    int max = 0;
    for (int i=1; i <= b; i++) {
        if (a % i == 0 && b % i == 0) {
            max = i;
        }
    }
    return max;
}
//辗转相除法
int maxCommonDiviso2(int a,int b){
    int r;
    while (a % b > 0) {
        r = a % b;
        a = b;
        b = r;
    }
    return b;
}



int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
    }
    return 0;
}
