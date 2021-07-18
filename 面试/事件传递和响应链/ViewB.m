//
//  ViewB.m
//  Test
//
//  Created by chen chen on 2021/7/1.
//  Copyright © 2021 chen chen. All rights reserved.
//

#import "ViewB.h"

@implementation ViewB


/*
 此处可以做事件拦截
 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    NSLog(@"view b hit test");
    return [super hitTest:point withEvent:event];
}
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    NSLog(@"view b point inside");
    return [super pointInside:point withEvent:event];
}
@end
