//
//  ViewController.m
//  Test
//
//  Created by chen chen on 2021/6/15.
//  Copyright © 2021 chen chen. All rights reserved.
//

#import "ViewController.h"
#import "BlockTest.h"
#import "RunloopTest.h"
#import "EventAndResponderTest.h"
#import "ViewC+ActionFrame.h"

@interface ViewController ()
@property(nonatomic,strong) RunloopTest *runloop;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //block
//    [[[BlockTest alloc ]init]test];
    
    //runloop
//    self.runloop = [[RunloopTest alloc ]init];
//    [self.runloop test];
    
    //事件传递和响应链
    ViewA *a = [[ViewA alloc]initWithFrame:CGRectMake(0, 100, 400, 400)];
    a.backgroundColor = [UIColor redColor];
    ViewB *b = [[ViewB alloc]initWithFrame:CGRectMake(0, 100, 200, 400)];
    b.backgroundColor = [UIColor yellowColor];
    ViewC *c = [[ViewC alloc]initWithFrame:CGRectMake(0, 100, 100, 100)];
    c.backgroundColor = [UIColor greenColor];
    [c addTarget:self action:@selector(cAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:a];
    [a addSubview:b];
    [b addSubview:c];
    //修改c响应范围
    [c setEnlargeEdgeWithTop:20 right:20 bottom:-20 left:-10];
    /*
     事件的传递和响应链
  当一个事件触发，系统会将事件放入UIApplication事件处理队列中，UIApplication从队列中取出事件发送给UIWindow,UIWindow通过hitTest去寻找最合适的view处理事件。（事件传递）
    hitTest调用时机是在事件传给它就会调用hitTest，并且通过pointInside判断点是否在它上面，如果在它上面就会将它的所有子控件都调用hitTest和pointInside继续查找。如果子控件没有找到那么它的父控件就是最适合的。
        如果父控件不能接受触摸事件，那么子控件就不可能接收到触摸事件。
     找到最适合的view，当view不能处理事件时会将事件传给它的下一个响应者处理，一直找不到能处理的对象，最终会传回UIApplication，如果UIApplication也不能处理那么此事件将被丢弃。（响应链）
     view 是否能处理事件，即看view是否重写了touches的方法。当view没有重写touches方法处理事件，则会直接super 调用touches方法传到下一个响应者。
     */

}
-(void)cAction{
    NSLog(@"c action");
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.runloop addEvent:@selector(threadTest) target:self];
}

-(void)threadTest{
    NSLog(@"run==%@",[NSThread currentThread]);
}
@end
