//
//  LGViewController.m
//  001---KVO初探
//
//  Created by cooci on 2019/1/3.
//  Copyright © 2019 cooci. All rights reserved.
//

#import "LGViewController.h"
#import "LGDetailViewController.h"
#import "LGStudent.h"

static void *PersonNickContext = &PersonNickContext;
static void *PersonNameContext = &PersonNameContext;

@interface LGViewController ()
@property (nonatomic, strong) LGPerson  *person;
@property (nonatomic, strong) LGStudent *student;
@end

@implementation LGViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.person  = [LGPerson new];
    self.student = [LGStudent shareInstance];

    // 1: context : 上下文
    // 多个对象 - 多个属性
    // 2: 移除观察者
    
    [self.person addObserver:self forKeyPath:@"nick" options:NSKeyValueObservingOptionNew context:NULL];
    
    // 3: 手动和自动
//    [self.student addObserver:self forKeyPath:@"name" options:(NSKeyValueObservingOptionNew) context:NULL];
    // 4: 路径处理
    // 下载的进度 = 已下载 / 总下载
    [self.person addObserver:self forKeyPath:@"downloadProgress" options:(NSKeyValueObservingOptionNew) context:NULL];
    // 5: 数组观察
    self.person.dateArray = [NSMutableArray arrayWithCapacity:1];
    //观察者数组的KVO，必须利用KVC的原理机制才可以观察到
    [self.person addObserver:self forKeyPath:@"dateArray" options:(NSKeyValueObservingOptionNew) context:NULL];

}


- (IBAction)didClickRightItmePushItem:(id)sender {
    
    LGDetailViewController *detailVC = [[LGDetailViewController alloc] init];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.person.nick = [NSString stringWithFormat:@"%@+",self.person.nick];
//    self.person.writtenData += 10;
//    self.person.totalData  += 1;
    // KVC 集合 array
    [[self.person mutableArrayValueForKey:@"dateArray"] addObject:@"1"];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    // fastpath
    // 性能 + 代码可读性
    NSLog(@"%@",change);
}


- (void)dealloc{
//    [self.person removeObserver:self forKeyPath:@"nick" context:NULL];
    [self.person removeObserver:self forKeyPath:@"dateArray"];

}

@end
