//
//  WYPerson+cate.m
//  关联对象
//
//  Created by 张文艺 on 2021/10/19.
//

#import "WYPerson+cate.h"
#import <objc/runtime.h>

@implementation WYPerson (cate)

- (void)setCate_name:(NSString *)cate_name{

    /*
     1：对象
     2：标识符
     3：value
     4：策略
     */
    objc_setAssociatedObject(self, "cate_name", cate_name, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)cate_name{
    /*
     1：对象
     2：标识符
     */
    return  objc_getAssociatedObject(self, "cate_name");
}

- (void)removeAssociation{
    objc_setAssociatedObject(self, "cate_name", nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
