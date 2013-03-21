//
//  HeavyViewController.m
//  HeavyRotation
//
//  Created by Long Vinh Nguyen on 1/27/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import "HeavyViewController.h"


@implementation HeavyViewController

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (BOOL)shouldAutorotate
{
    return YES;
}


@end
