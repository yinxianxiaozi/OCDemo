//
//  WYBlock.h
//  Block的学习
//
//  Created by 张文艺 on 2021/11/7.
//

#import <Foundation/Foundation.h>

@class WYBlock;
NS_ASSUME_NONNULL_BEGIN

//定义一个block
typedef int (^myBlock)(int num1,int num2);
typedef void (^myBlock2)(WYBlock *);

/*
 block作为属性有两种，一种是先定义再设置，一种是直接定义到属性中
 */
@interface WYBlock : NSObject
@property (nonatomic,strong) NSString *name;
//作为属性，就和实例变量完全一样，block要使用copy修饰（虽然不用也行）
@property (nonatomic,copy) myBlock block1;
@property (nonatomic,copy) myBlock2 block11;

//也可以这么写，将block定义直接放到这里
@property (nonatomic,copy) void (^myBlock2)(int num1,int num2);

//block作为参数传递
- (void)sumWithblock:(myBlock) block2;
- (void)sumWithblock2:(int (^)(int num1,int num2)) block3;
- (void)sumWithblock3:( void (^)(int num1,int num2)) block4;
- (void)testVariable;
- (void)blockType;
- (void)circularTest;
- (void)circularTest1;
- (void)circularTest2;
- (void)circularTest3;
- (void)circularTest4;
- (void)circularTest5;
- (void)circularTest6;
- (void)eat;
@end

NS_ASSUME_NONNULL_END
