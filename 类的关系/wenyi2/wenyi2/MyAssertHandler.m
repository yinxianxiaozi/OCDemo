//
//  MyAssertHandler.m
//  wenyi2
//
//  Created by 张文艺 on 2021/8/2.
//

#import "MyAssertHandler.h"

@implementation MyAssertHandler

//OC方法
- (void)handleFailureInMethod:(SEL)selector object:(id)object file:(NSString *)fileName lineNumber:(NSInteger)line description:(NSString *)format, ...{
    NSLog(@"NSAssert Failure: Method %@ for object %@ in %@#%li description:%@", NSStringFromSelector(selector), object, fileName, (long)line,format);
}

//C函数
- (void)handleFailureInFunction:(NSString *)functionName file:(NSString *)fileName lineNumber:(NSInteger)line description:(NSString *)format, ...{
    NSLog(@"NSCAssert Failure: Function (%@) in %@#%li", functionName, fileName, (long)line);
}
@end
