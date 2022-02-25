//
//  WYPerson.h
//  拷贝的学习
//
//  Created by 张文艺 on 2021/11/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WYPerson : NSObject<NSCopying,NSMutableCopying>

@property (nonatomic,copy) NSString *str;

@end

NS_ASSUME_NONNULL_END
