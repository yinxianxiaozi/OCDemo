//
//  GCDTest.h
//  多线程使用
//
//  Created by 张文艺 on 2021/10/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GCDTest : NSObject
- (void)mainSyncTest;
- (void)mainAsyncTest;
- (void)globalAsyncTest;
- (void)globalSyncTest;
- (void)textDemo2;
- (void)textDemo1;
- (void)textDemo;
- (void)concurrentSyncTest;
- (void)concurrentAsyncTest;
- (void)serialAsyncTest;
- (void)serialSyncTest;
- (void)cjl_testGroup2;
- (void)cjl_testBarrier;
- (void)cjl_testSemaphore;
@end

NS_ASSUME_NONNULL_END
