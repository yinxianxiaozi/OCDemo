//
//  WYPerson.h
//  KVO分析
//
//  Created by 张文艺 on 2021/10/22.
//

#import <Foundation/Foundation.h>
#import "WYStudent.h"

NS_ASSUME_NONNULL_BEGIN

typedef struct {
    float x, y, z;
} ThreeFloats;

@interface WYPerson : NSObject{
   @public
   NSString *myName;//成员变量
}

@property (nonatomic, copy)   NSString          *name;
@property (nonatomic, strong) NSArray           *array;
@property (nonatomic, strong) NSMutableArray    *mArray;
@property (nonatomic, assign) int               age;
@property (nonatomic)         ThreeFloats       threeFloats;
@property (nonatomic, strong) WYStudent         *student;

@end

NS_ASSUME_NONNULL_END
