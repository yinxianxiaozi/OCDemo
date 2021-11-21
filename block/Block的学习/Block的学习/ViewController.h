//
//  ViewController.h
//  Block的学习
//
//  Created by 张文艺 on 2021/11/5.
//

#import <UIKit/UIKit.h>
typedef void (^addBlock2)(int num1,int num2);
@interface ViewController : UIViewController

- (addBlock2)add;
@end

