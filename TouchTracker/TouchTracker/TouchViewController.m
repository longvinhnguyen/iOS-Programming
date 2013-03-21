//
//  TouchViewController.m
//  TouchTracker
//
//  Created by Long Vinh Nguyen on 2/5/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import "TouchViewController.h"
#import "TouchDrawView.h"

@implementation TouchViewController

- (void)loadView
{
    [self setView:[[TouchDrawView alloc] initWithFrame:CGRectZero]];
}

@end
