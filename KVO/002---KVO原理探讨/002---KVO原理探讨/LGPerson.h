//
//  LGPerson.h
//  002---KVO原理探讨
//
//  Created by cooci on 2019/1/5.
//  Copyright © 2019 cooci. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LGPerson : NSObject{
    @public
    NSString *name;
}
@property (nonatomic, copy) NSString *nickName;

@end

NS_ASSUME_NONNULL_END
