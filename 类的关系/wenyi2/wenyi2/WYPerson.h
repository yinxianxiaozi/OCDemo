//
//  WYPerson.h
//  wenyi2
//
//  Created by 张文艺 on 2021/7/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WYPerson : NSObject
{
    int age;
    NSString *sex;
}
@property (nonatomic,strong) NSString *name;

- (void) eat;
- (void)drink:(NSString *)car;
@end

NS_ASSUME_NONNULL_END
