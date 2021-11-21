//
//  WYStudent.h
//  KVO分析
//
//  Created by 张文艺 on 2021/10/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WYStudent : NSObject
@property (nonatomic, copy)   NSString          *name;
@property (nonatomic, copy)   NSString          *subject;
@property (nonatomic, copy)   NSString          *nick;
@property (nonatomic, assign) int               age;
@property (nonatomic, assign) int               length;
@property (nonatomic, strong) NSMutableArray    *penArr;

@end

NS_ASSUME_NONNULL_END
