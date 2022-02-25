//
//  ViewController.m
//  通知
//
//  Created by 张文艺 on 2021/11/23.
//

#import "ViewController.h"
#import "NSPerson.h"

@interface ViewController ()
@property (nonatomic,strong) NSPerson *person;




@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.person = [NSPerson alloc];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eat) name:@"eat" object:nil];
    [self.person drink];
}

- (void)eat:(NSString *)s{
    
}

- (void)eat{
    NSLog(@"%s:eat",__func__);
}


@end
