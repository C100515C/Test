//
//  RunloopTest.h
//  Test
//
//  Created by chen chen on 2021/6/30.
//  Copyright © 2021 chen chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RunloopTest : NSObject

-(void)test;

-(void)addEvent:(SEL)action target:(id)target;
@end

NS_ASSUME_NONNULL_END
