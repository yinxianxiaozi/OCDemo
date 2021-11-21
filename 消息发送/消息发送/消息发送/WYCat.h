//
//  WYCat.h
//  消息发送
//
//  Created by 张文艺 on 2021/10/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WYCat : NSObject

@property (nonatomic ,assign ,readonly) int age;
@property (nonatomic, copy,readwrite) NSString *name;

//- (void)eat;

@end

NS_ASSUME_NONNULL_END
