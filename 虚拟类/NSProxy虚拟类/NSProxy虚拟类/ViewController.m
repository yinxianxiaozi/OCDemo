//
//  ViewController.m
//  NSProxy虚拟类
//
//  Created by 张文艺 on 2021/11/8.
//

#import "ViewController.h"
#import "WYProxy.h"
#import "WYPerson.h"
#import "WYStudent.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self proxyTest];
    // Do any additional setup after loading the view.
}

/*
 通过WYProxy代理WYStudent和WYPerson
 */

/*
 先将需要代理的对象作为属性存储到WYProxy中，之后proxy在调用方法时，会主动进行方法转发，转发给这个对象
 */

- (void)proxyTest {
    WYPerson *person = [WYPerson alloc];
    WYStudent *student = [WYStudent alloc];
    WYProxy *proxy = [WYProxy alloc];
    
    //代理person
    [proxy transformObjc:person];
    [proxy performSelector:@selector(eat)];
    
    //代理student
    [proxy transformObjc:student];
    [proxy performSelector:@selector(eat)];
}


@end
