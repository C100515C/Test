//
//  ViewC+ActionFrame.h
//  Test
//
//  Created by chen chen on 2021/7/18.
//  Copyright © 2021 chen chen. All rights reserved.
//

#import "ViewC.h"

NS_ASSUME_NONNULL_BEGIN
//扩大按钮c 点击范围
@interface ViewC (ActionFrame)
-(void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;
@end

NS_ASSUME_NONNULL_END
