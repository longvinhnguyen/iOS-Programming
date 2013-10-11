//
//  ViewController.m
//  6.8-CAReplicatorLayer
//
//  Created by Long Vinh Nguyen on 10/11/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CAReplicatorLayer *replicateLayer = [CAReplicatorLayer layer];
    replicateLayer.frame = self.view.bounds;
    replicateLayer.position = self.view.center;
    [self.view.layer addSublayer:replicateLayer];
    
    // configure the replicator
    replicateLayer.instanceCount = 10;
    
    // apply transform for each instance
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DTranslate(transform, 0, 200, 0);
    transform = CATransform3DRotate(transform, M_PI / 5.0, 0, 0, 1);
    transform = CATransform3DTranslate(transform, 0, -200, 0);
    replicateLayer.instanceTransform = transform;
    
    replicateLayer.instanceBlueOffset = -0.1;
    replicateLayer.instanceGreenOffset = -0.1;
    
    // create a sublayer and place it inside the replicator
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(100.0f, 100.0f, 100.0f, 100.0f);
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    [replicateLayer addSublayer:layer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight;
}

@end
