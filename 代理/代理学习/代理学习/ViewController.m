//
//  ViewController.m
//  代理学习
//
//  Created by 张文艺 on 2021/11/12.
//

#import "ViewController.h"
#import "WYDog.h"
#import "WYCat.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WYDog *dog = [WYDog alloc];
    WYCat *cat = [WYCat alloc];
    dog.delegate = cat;
    [dog eatFood];
}


@end
