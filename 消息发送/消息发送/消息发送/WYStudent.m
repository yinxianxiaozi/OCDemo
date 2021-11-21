//
//  WYStudent.m
//  消息发送
//
//  Created by 张文艺 on 2021/10/15.
//

#import "WYStudent.h"
#import "WYPerson.h"

@implementation WYStudent

- (void)objc_msgSendSuperTest{
    NSLog(@"父类：%@---子类：%@",[super class],[self class]);
}
@end
