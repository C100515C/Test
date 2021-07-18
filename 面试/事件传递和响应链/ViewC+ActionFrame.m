//
//  ViewC+ActionFrame.m
//  Test
//
//  Created by chen chen on 2021/7/18.
//  Copyright © 2021 chen chen. All rights reserved.
//

#import "ViewC+ActionFrame.h"
#import <objc/runtime.h>

static NSString *topNameKey = @"topNameKey";
static NSString *rightNameKey = @"rightNameKey";
static NSString *leftNameKey = @"leftNameKey";
static NSString *bottomNameKey = @"bottomNameKey";

@implementation ViewC (ActionFrame)
#pragma mark- 利用 **runtime** 具体的设置内边距
// 设置可点击范围到按钮上、右、下、左的距离
-(void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left
{
    objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:top], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:left], OBJC_ASSOCIATION_COPY_NONATOMIC);
    
}

-(CGRect)enlargedRect
{
    NSNumber *topEdge=objc_getAssociatedObject(self, &topNameKey);
    NSNumber *rightEdge=objc_getAssociatedObject(self, &rightNameKey);
    NSNumber *bottomEdge=objc_getAssociatedObject(self, &bottomNameKey);
    NSNumber *leftEdge=objc_getAssociatedObject(self, &leftNameKey);
    if(topEdge && rightEdge && bottomEdge && leftEdge){
        return CGRectMake(self.bounds.origin.x-leftEdge.floatValue,
                          self.bounds.origin.y-topEdge.floatValue,
                          self.bounds.size.width+leftEdge.floatValue+rightEdge.floatValue,
                          self.bounds.size.height+topEdge.floatValue+bottomEdge.floatValue);
    }else{
        return self.bounds;
    }
}

// 设置可点击范围到按钮上、右、下、左的距离
-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect rect=[self enlargedRect];
    if(CGRectEqualToRect(rect, self.bounds))
    {
        return [super pointInside:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point)?YES:NO;
}
@end
