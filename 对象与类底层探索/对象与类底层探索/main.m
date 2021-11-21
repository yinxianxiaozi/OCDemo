//
//  main.m
//  对象与类底层探索
//
//  Created by 张文艺 on 2021/10/12.
//

#import <Foundation/Foundation.h>
#import "WYPerson.h"

//@interface WYPerson : NSObject
//
//@property (nonatomic, assign) int age;
//
//@end
//
//@implementation WYPerson
//
//- (void)eat{
//    NSLog(@"eat");
//}

@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        WYPerson *person = [[WYPerson alloc] init];
        // insert code here...
        NSLog(@"Hello, World!");
    }
    return 0;
}
