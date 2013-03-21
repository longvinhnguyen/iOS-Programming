//
//  BNRExecutor.m
//  Blocky
//
//  Created by Long Vinh Nguyen on 2/15/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import "BNRExecutor.h"

@implementation BNRExecutor
@synthesize equation;

- (int)computeWithValue:(int)value1 addValue:(int)value2
{
    // If a block varible is executed but doesn't point at a block
    // it will crash - retrun 0 if there is no block
    if (!equation) {
        return 0;
    }
    
    return equation(value1, value2);
}

- (void)dealloc
{
    NSLog(@"Executor is being destroyed");
}


@end
