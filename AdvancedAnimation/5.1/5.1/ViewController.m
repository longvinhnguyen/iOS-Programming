//
//  ViewController.m
//  5.1
//
//  Created by Long Vinh Nguyen on 10/5/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "ViewController.h"

CGAffineTransform CAAffineTransformShear(CGFloat x, CGFloat y)
{
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform.c = -x;
    transform.b = y;
    return transform;
}

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, weak) IBOutlet UIImageView *layerView1;
@property (nonatomic, weak) IBOutlet UIImageView *layerView2;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // apply the perspective transform to container
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = -1.0f/500;
    self.containerView.layer.sublayerTransform = perspective;
    
    self.layerView2.layer.doubleSided = NO;
    CATransform3D transform1 = CATransform3DMakeRotation(M_PI_4, 0, 0, 1);
    self.layerView1.layer.transform = transform1;
    
    CATransform3D transform2 = CATransform3DMakeRotation(M_PI/180 * 90, 0, 0, 1);
    self.layerView2.layer.transform = transform2;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
