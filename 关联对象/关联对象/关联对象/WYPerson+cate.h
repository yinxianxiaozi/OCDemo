//
//  WYPerson+cate.h
//  关联对象
//
//  Created by 张文艺 on 2021/10/19.
//

#import "WYPerson.h"

NS_ASSUME_NONNULL_BEGIN

@interface WYPerson (cate)

@property (nonatomic,copy) NSString *cate_name;
- (void)removeAssociation;
@end

NS_ASSUME_NONNULL_END
