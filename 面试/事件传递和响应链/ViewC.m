//
//  ViewC.m
//  Test
//
//  Created by chen chen on 2021/7/1.
//  Copyright © 2021 chen chen. All rights reserved.
//

#import "ViewC.h"

@implementation ViewC
/*
 按钮点击事件被截获无法响应
*/
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"view c event:%@",event);
    [super touchesBegan:touches withEvent:event];//super调用事件可以被继续传递
}
/*
 此处可以做事件拦截
 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    NSLog(@"view c hit test");
    return [super hitTest:point withEvent:event];
}
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    NSLog(@"view c point inside");
    return [super pointInside:point withEvent:event];
    /*//扩大按钮响应范围
    // 当前btn的大小
    CGRect btnBounds=self.bounds;
    // 扩大按钮的点击范围，改为负值
    btnBounds=CGRectInset(btnBounds, -50, -50);
    // 若点击的点在新的bounds里，就返回YES
    return CGRectContainsPoint(btnBounds, point);*/
}

@end
