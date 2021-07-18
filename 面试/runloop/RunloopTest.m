//
//  RunloopTest.m
//  Test
//
//  Created by chen chen on 2021/6/30.
//  Copyright © 2021 chen chen. All rights reserved.
//

#import "RunloopTest.h"
@interface RunloopTest()
@property(nonatomic,strong) NSThread *thread;
@end
@implementation RunloopTest
/*
 runloop是循环处理程序中各种事件的循环，让程序保持运行，在没有事件处理时候让线程处于休眠。没有事件处理的时候从用户态切换到内核态，线程休眠。当有事件要出来从内核态切换到用户态，处理事件，是一个状态直接的切换。
 
 一个线程会对应一个runloop，主线程runloop默认开启，子线程需要手动开启。runloop存在全局的一个字典里面，以线程为key，runloop为value。runloop对象在第一次获取时候创建在线程结束时候销毁。
 
 NSRunloop 是对CFRunLoop的面向对象封装。
 CFRunLoop 主要包括 CFRunLoopRef CFRunLoopMode CFRunLoopSourceRef CFRunLoopObserverRef
 一个线程对应一个runloop，一个runloop可以对应多个mode，mode包含多种source（sourc0，source1，timer，observer）。不同model之间互不影响。
 
 runloop有五种模式：
 
 kCFRunLoopDefaultMode
 UITrackingRunLoopMode
 UIInitializationRunLoopMode
 GSEventReceiveRunLoopMode
 kCFRunLoopCommonModes
 
 其中kCFRunLoopCommonModes可以用来处理多个mode之间相互影响的问题，常见问题是列表上头部banner定时器自动轮播和滑动列表之间相互影响问题。
kCFRunLoopCommonModes 是一种伪mode，实际上是在切换mode时候，会把timer事件带着，add到切换的mode里面，这样timer就会一直运行。
 
 runloop用处：
 1.常驻子线程
 2.列表上图片延迟加载
 3.阻止app奔溃
 4.检查app卡顿
 5.定时器
 */
- (void)test {
    [self thread];
}
- (NSThread *)thread{
    if (_thread==nil) {
        _thread = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
        [_thread setName:@"test1"];
        [_thread start];
    }
    return _thread;
}
- (void)addEvent:(SEL)action target:(id)target{
    [self performSelector:@selector(threadTest) onThread:self.thread withObject:nil waitUntilDone:YES];
    [target performSelector:@selector(threadTest) onThread:self.thread withObject:nil waitUntilDone:YES];
}
-(void)threadTest{
    NSLog(@"run==%@",[NSThread currentThread]);
}
//常驻子线程
-(void)run{
//    [self run1];//方式一
//    [self run2];//方式二
//    [self run3];//方式三
    [self run4];
}
//通过向runloop中添加source
-(void)run1{
    CFRunLoopSourceContext context = {0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL};
    CFRunLoopSourceRef source = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &context);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
    BOOL stop = NO;
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        switch (activity) {
    //当runloop进入空闲时,即方法执行完毕后,判断runloop的开关,如果关闭就执行关闭操作
            case kCFRunLoopBeforeWaiting:
            {
                NSLog(@"即将进入睡眠1");
                /*if (stop) {
                    NSLog(@"关闭runloop");
                    // 移除runloop的source
                CFRunLoopRemoveSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
                    CFRelease(source);
                    // 没有source的runloop是可以通过stop方法关闭的
                    CFRunLoopStop(CFRunLoopGetCurrent());
                }*/
                break;
            }
            case kCFRunLoopBeforeSources:{
                NSLog(@"接收处理source2");
                break;
            }
            case kCFRunLoopAfterWaiting:{
                NSLog(@"退出等待3");
                break;
            }
            case kCFRunLoopBeforeTimers:{
                NSLog(@"接收处理timer4");
                break;
            }
                
        }
    });
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);
    BOOL runAlways = YES;
    while (runAlways) {
        NSLog(@"thread run5 =%@",[NSThread currentThread]);
        CFRunLoopRun();
    }
    CFRunLoopRemoveSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
    CFRelease(source);
}
//添加port让runloop一直跑
-(void)run2{
    NSPort *port = [NSPort port];
    NSLog(@"port retainCount1 = %lu",(unsigned long)CFGetRetainCount((__bridge CFTypeRef)port));
    [[NSRunLoop currentRunLoop] addPort:port forMode:NSDefaultRunLoopMode];
    NSLog(@"port retainCount2 = %lu",(unsigned long)CFGetRetainCount((__bridge CFTypeRef)port));
    [[NSRunLoop currentRunLoop] run];
//    [[NSRunLoop currentRunLoop] removePort:port forMode:NSDefaultRunLoopMode];
//    NSLog(@"port retainCount3 = %lu",(unsigned long)CFGetRetainCount((__bridge CFTypeRef)port));

    /*
     NSPort 添加 到runloop  存在内存泄漏风险。 在添加到runlopp中引用计数会+3，remove会-2.
     */
}
//添加定时器NSTimer
-(void)run3{
    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
    [runloop addTimer:timer forMode:NSRunLoopCommonModes];
//    [timer fire];
    [runloop run];
    /*
     使用NSTimer 存在内存泄漏问题 self -> thread -> runloop -> timer -> self 这是一个引用循环，使用时需要注意打破循环
     self不要强引用timer 在timer中使用weak self 或者接入中间对象
     手动停止timer（ [timer invalidate];） 在释放timer
     */
}

-(void)timerRun{
    NSLog(@"timer=%@",[NSThread currentThread]);
    
}
//取巧方式 死循环
-(void)run4{
    while (1) {
        [[NSRunLoop currentRunLoop] run];
    }
}

@end
