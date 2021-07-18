//
//  BlockTest.m
//  Test
//
//  Created by chen chen on 2021/6/30.
//  Copyright © 2021 chen chen. All rights reserved.
//

#import "BlockTest.h"
/*
 block 在arc和mrc 下共有三种类型的block
 分别是globalblock，stackblock，mallocblock
 在mrc下有这三种，但是在arc下只有globalblock和mallocblock;stackblock会调用copy函数自动转为mallocblock（注释：有特例情况）;globalblock调用copy还是globalblock；
 
 */
@implementation BlockTest
- (void)test{
    /*
     没有访问外部auto变量的或者访问的是static 和全局变量的即为全局block
     */
    void (^global)(int) = ^(int a){
        NSLog(@"%d",a);
    };
    global(1);
    NSLog(@"global=%@",[global class]);
    
    /*
     访问外部auto变量的即为栈block，在arc下会自动调用copy函数 所有打印是堆block
     */
    int val = 2;
    void (^stack)(int) = ^(int a){
        NSLog(@"%d",val);
    };
    stack(2);
    NSLog(@"stack=%@",[stack class]);

    /*
     栈block调用了copy函数变为堆block
     */
    int value = 3;
    void (^malloc)(int) = [^(int a){
        NSLog(@"%d",value);
    } copy];
    malloc(3);
    NSLog(@"malloc=%@",[malloc class]);
    
    /*
     全局block调用了copy函数还是全局block
     */
    void (^global1)(int) = [^(int a){
        NSLog(@"%d",a);
    } copy];
    global1(4);
    NSLog(@"global=%@",[global1 class]);
    
    /*
     特例情况  arc下不会自动调用copy函数 执行异常
     */
    [self testBlock];
    
    /*
     block 内部无法修改auto变量
     */
    [self test1];
}

//block 内部无法修改auto变量
/*
 一般block 外部变量默认都是auto 变量，在block内部引用block会捕获瞬时值，将变量值捕获到block内部就固定不变，不受变量改变的影响。而且在block内部无法修改变量的值会报错。但是如果捕获的是对象，在block内部对象是可以修改对象内部数据，例如数组修改数组元素。
 如果想要在block内部修改外部变量需要用到__block 修饰变量
 __block 原理：内部会有一个指针指向结构体，通过结构体找到结构体的内存把结构体中的值给改掉；被__block修饰会把变量包装成一个对象，对象内部可以访问到变量，即可对变量进行读写
 
 */
-(void)test1{
    int a = 10;
    NSObject *obj = [NSObject new];
    NSMutableArray *arr = [NSMutableArray array];
    __block int d = 11;
    void (^block)(int,NSObject*) = ^(int b, NSObject *c){
//        a = 11; //error 编译直接报错
//        obj = [NSObject new]; //error
        //block参数传进来在内部可以修改赋值 不影响外部变量
        b = 16;
        c = [NSDictionary dictionary];
        NSLog(@"test1 b=%d  c=%@",b,c);
        
        [arr addObject:@"33"];
        d = 13;
        NSLog(@"test1 d=%d a=%d  obj=%@  arr=%@",d,a,obj,arr);
    };
    a = 11;
    obj = [NSArray new];
    [arr addObject:@"44"];
    d = 12;
    block(a,obj);
    NSLog(@"test1 d=%d a=%d  obj=%@   arr=%@",d,a,obj,arr);
}

//特例情况  arc下不会自动调用copy函数的情况  解决办法是手动调用copy函数
-(void)testBlock{
    NSArray *temp = [self getBlock];
    void (^block1)(void) = [temp objectAtIndex:0];
    block1();
}
-(NSArray*)getBlock{
    int val = 5;
//    return [NSArray arrayWithObjects:^{
//        NSLog(@"block1=%d",val);
//    },^{
//        NSLog(@"block2=%d",val);
//    }, nil];
    return [NSArray arrayWithObjects:[^{
        NSLog(@"block1=%d",val);
    } copy],[^{
        NSLog(@"block2=%d",val);
    } copy], nil];
}

@end
