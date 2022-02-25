//
//  WYPerson.m
//  拷贝的学习
//
//  Created by 张文艺 on 2021/11/26.
//

#import "WYPerson.h"

@implementation WYPerson

- (void)testCopy {
//    NSMutableString *ms = self.str;
}


- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    WYPerson *person = [[[self class] allocWithZone:zone] init];
    return person;
}

- (nonnull id)mutableCopyWithZone:(nullable NSZone *)zone {
    WYPerson *person = [[[self class] allocWithZone:zone] init];
    return person;
}

@end
