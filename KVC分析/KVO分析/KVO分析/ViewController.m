//
//  ViewController.m
//  KVO分析
//
//  Created by 张文艺 on 2021/10/22.
//

#import "ViewController.h"
#import "WYPerson.h"
#import "WYStudent.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    //属性
    [self propertyTest];
    //keyPath访问
    [self keyPathTest];
    //集合
    
    //结构体
    [self structTest];
    
    //动态数组取值
    [self arrayTest];
    
    //字典操作
    [self dictionaryTest];
    
    //KVC消息传递
    [self arrayMessagePass];
    //聚合操作符
    [self aggregationOperator];
    //数组操作符
    [self arrayOperator];
    //嵌套集合操作
    [self arrayNesting];
    [self setNesting];
    
}

//属性
- (void)propertyTest{
    WYPerson *person = [[WYPerson alloc] init];
    [person setValue:@"zwy" forKey:@"name"];
    
    NSLog(@"person的name为：%@",[person valueForKey:@"name"]);
}

//keyPath访问

- (void)keyPathTest{
    WYPerson *person = [[WYPerson alloc] init];
    WYStudent *student = [[WYStudent alloc] init];
    person.student = student;
    
    [person setValue:@"studentWY" forKeyPath:@"student.name"];
    
    NSLog(@"person下的student的name为：%@",[person valueForKeyPath:@"student.name"]);
}


//集合

- (void)aggregateTest{
    
}

//结构体

-(void)structTest{
    //非对象属性，需要包装成对象再使用
    WYPerson *person = [[WYPerson alloc] init];
    ThreeFloats floats = {1.,2.,3.};
    NSValue *value     = [NSValue valueWithBytes:&floats objCType:@encode(ThreeFloats)];
    [person setValue:value forKey:@"threeFloats"];
    NSValue *value1    = [person valueForKey:@"threeFloats"];
    ThreeFloats th;
    [value1 getValue:&th];
    NSLog(@"结构体threeFloats的值为：%f-%f-%f",th.x,th.y,th.z);
}

//动态数组取值
- (void)arrayTest{
    WYStudent *student = [[WYStudent alloc] init];
    student.penArr = [NSMutableArray arrayWithObjects:@"pen0", @"pen1", @"pen2", @"pen3", nil];
    NSArray *arr = [student valueForKey:@"penArr"]; // 动态成员变量
    NSLog(@"array的值为：%@",arr);
}

//字典操作
- (void)dictionaryTest{
    
    NSDictionary* dict = @{
                           @"name":@"zwy",
                           @"age":@18,
                           @"length":@180
                           };
    WYStudent *student = [[WYStudent alloc] init];
    // 字典转模型
    [student setValuesForKeysWithDictionary:dict];
    NSLog(@"student:%@",student);
    // 键数组转模型到字典，只获取其中的某些属性组成字典
    NSArray *array = @[@"name",@"age"];
    NSDictionary *dic = [student dictionaryWithValuesForKeys:array];
    NSLog(@"字典：%@",dic);
}

//KVC消息传递
//可以对数组的元素进行操作，并且返回一个数组
//直接通过keypath传入元素的属性
- (void)arrayMessagePass{
    NSArray *array = @[@"Hank",@"Cooci",@"Kody",@"CC",@"13"];
    NSArray *lenStr= [array valueForKeyPath:@"length"];
    // 消息从array传递给了string，所以获取的并不是数组的长度，而是数组中字符串的长度
    NSLog(@"每个字符串的长度：%@",lenStr);
    NSArray *lowStr= [array valueForKeyPath:@"lowercaseString"];
    NSLog(@"%@",lowStr);
    NSArray *doubleArray = [array valueForKeyPath:@"doubleValue"];
    NSLog(@"%@",doubleArray);
    
    WYPerson *p1 = [[WYPerson alloc] init];
    p1.name = @"p1";
    p1.age = 12;
    WYPerson *p2 = [[WYPerson alloc] init];
    p2.name = @"p2";
    p2.age = 13;
    WYPerson *p3 = [[WYPerson alloc] init];
    p3.name = @"pfsafd";
    p3.age = 15;
    
    NSArray *pArray = @[p1,p2,p3];
    NSArray *name = [pArray valueForKeyPath:@"name"];
    NSLog(@"name--%@",name);
    NSArray *age = [pArray valueForKeyPath:@"age"];
    NSLog(@"age--%@",age);
}

//聚合操作符
// @avg、@count、@max、@min、@sum
- (void)aggregationOperator{
    NSMutableArray *personArray = [NSMutableArray array];
    for (int i = 0; i < 6; i++) {
        WYStudent *p = [WYStudent new];
        NSDictionary* dict = @{
                               @"name":@"Tom",
                               @"age":@(18+i),
                               @"nick":@"Cat",
                               @"length":@(175 + 2*arc4random_uniform(6)),
                               };
        [p setValuesForKeysWithDictionary:dict];
        [personArray addObject:p];
    }
    NSLog(@"%@", [personArray valueForKey:@"length"]);
    
    /// 平均身高
    float avg = [[personArray valueForKeyPath:@"@avg.length"] floatValue];
    NSLog(@"%f", avg);
    
    int count = [[personArray valueForKeyPath:@"@count.length"] intValue];
    NSLog(@"%d", count);
    
    int sum = [[personArray valueForKeyPath:@"@sum.length"] intValue];
    NSLog(@"%d", sum);
    
    int max = [[personArray valueForKeyPath:@"@max.length"] intValue];
    NSLog(@"%d", max);
    
    int min = [[personArray valueForKeyPath:@"@min.length"] intValue];
    NSLog(@"%d", min);
}

// 数组操作符 @distinctUnionOfObjects @unionOfObjects
- (void)arrayOperator{
    NSMutableArray *personArray = [NSMutableArray array];
    for (int i = 0; i < 6; i++) {
        WYStudent *p = [WYStudent new];
        NSDictionary* dict = @{
                               @"name":@"Tom",
                               @"age":@(18+i),
                               @"nick":@"Cat",
                               @"length":@(175 + 2*arc4random_uniform(6)),
                               };
        [p setValuesForKeysWithDictionary:dict];
        [personArray addObject:p];
    }
    NSLog(@"%@", [personArray valueForKey:@"length"]);
    // 返回操作对象指定属性的集合
    NSArray* arr1 = [personArray valueForKeyPath:@"@unionOfObjects.length"];
    NSLog(@"arr1 = %@", arr1);
    // 返回操作对象指定属性的集合 -- 去重
    NSArray* arr2 = [personArray valueForKeyPath:@"@distinctUnionOfObjects.length"];
    NSLog(@"arr2 = %@", arr2);
    
}

// 嵌套集合(array&set)操作 @distinctUnionOfArrays @unionOfArrays @distinctUnionOfSets
- (void)arrayNesting{
    
    NSMutableArray *personArray1 = [NSMutableArray array];
    for (int i = 0; i < 6; i++) {
        WYStudent *student = [WYStudent new];
        NSDictionary* dict = @{
                               @"name":@"Tom",
                               @"age":@(18+i),
                               @"nick":@"Cat",
                               @"length":@(175 + 2*arc4random_uniform(6)),
                               };
        [student setValuesForKeysWithDictionary:dict];
        [personArray1 addObject:student];
    }
    
    NSMutableArray *personArray2 = [NSMutableArray array];
    for (int i = 0; i < 6; i++) {
        WYStudent *person = [WYStudent new];
        NSDictionary* dict = @{
                               @"name":@"Tom",
                               @"age":@(18+i),
                               @"nick":@"Cat",
                               @"length":@(175 + 2*arc4random_uniform(6)),
                               };
        [person setValuesForKeysWithDictionary:dict];
        [personArray2 addObject:person];
    }
    
    // 嵌套数组
    NSArray* nestArr = @[personArray1, personArray2];
    //得到数组中的所有数组元素的去重后的属性
    NSArray* arr = [nestArr valueForKeyPath:@"@distinctUnionOfArrays.length"];
    NSLog(@"arr = %@", arr);
    //得到数组中的所有数组元素的属性
    NSArray* arr1 = [nestArr valueForKeyPath:@"@unionOfArrays.length"];
    NSLog(@"arr1 = %@", arr1);
}

- (void)setNesting{
    
    NSMutableSet *personSet1 = [NSMutableSet set];
    for (int i = 0; i < 6; i++) {
        WYStudent *person = [WYStudent new];
        NSDictionary* dict = @{
                               @"name":@"Tom",
                               @"age":@(18+i),
                               @"nick":@"Cat",
                               @"length":@(175 + 2*arc4random_uniform(6)),
                               };
        [person setValuesForKeysWithDictionary:dict];
        [personSet1 addObject:person];
    }
    NSLog(@"personSet1 = %@", [personSet1 valueForKey:@"length"]);
    
    NSMutableSet *personSet2 = [NSMutableSet set];
    for (int i = 0; i < 6; i++) {
        WYStudent *person = [WYStudent new];
        NSDictionary* dict = @{
                               @"name":@"Tom",
                               @"age":@(18+i),
                               @"nick":@"Cat",
                               @"length":@(175 + 2*arc4random_uniform(6)),
                               };
        [person setValuesForKeysWithDictionary:dict];
        [personSet2 addObject:person];
    }
    NSLog(@"personSet2 = %@", [personSet2 valueForKey:@"length"]);

    // 嵌套set
    NSSet* nestSet = [NSSet setWithObjects:personSet1, personSet2, nil];
    // 交集
    NSArray* arr1 = [nestSet valueForKeyPath:@"@distinctUnionOfSets.length"];
    NSLog(@"arr1 = %@", arr1);
}

@end
