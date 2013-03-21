//
//  BNRExecutor.h
//  Blocky
//
//  Created by Long Vinh Nguyen on 2/15/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRExecutor : NSObject
{

}

@property (nonatomic, copy) int (^equation)(int a, int b);
- (int)computeWithValue:(int)value1 addValue:(int)value2;


@end
