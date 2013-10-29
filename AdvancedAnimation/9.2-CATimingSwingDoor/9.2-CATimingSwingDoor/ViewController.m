//
//  ViewController.m
//  9.2-CATimingSwingDoor
//
//  Created by VisiKard MacBook Pro on 10/29/13.
//  Copyright (c) 2013 VLong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UIView *containerView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // add the door
    CALayer *doorLayer = [CALayer layer];
    doorLayer.frame = CGRectMake(0, 0, 128, 256);
    doorLayer.position = CGPointMake(150 - 64, 150);
    doorLayer.anchorPoint = CGPointMake(0, 0.5);
    doorLayer.contents = (__bridge id)[UIImage imageNamed:@"Door.png"].CGImage;
    [self.containerView.layer addSublayer:doorLayer];
    
    // apply perspective transoform
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1/500.0f;
    self.containerView.layer.sublayerTransform = transform;
    
    // apply swinging animation
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation.y";
    animation.byValue = @(M_PI_2);
    animation.duration = 2.0f;
    animation.repeatCount = INFINITY;
    animation.autoreverses = YES;
    [doorLayer addAnimation:animation forKey:nil];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
