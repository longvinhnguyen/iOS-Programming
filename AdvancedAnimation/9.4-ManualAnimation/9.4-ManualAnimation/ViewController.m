//
//  ViewController.m
//  9.4-ManualAnimation
//
//  Created by VisiKard MacBook Pro on 10/29/13.
//  Copyright (c) 2013 VLong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, strong) CALayer *doorLayer;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // add the door
    self.doorLayer = [CALayer layer];
    self.doorLayer.frame = CGRectMake(0, 0, 128, 256);
    self.doorLayer.position = CGPointMake(150 -54, 150);
    self.doorLayer.anchorPoint = CGPointMake(0, 0.5);
    self.doorLayer.contents = (__bridge id)[UIImage imageNamed:@"Door.png"].CGImage;
    [self.containerView.layer addSublayer:self.doorLayer];
    
    // apply perspective transform
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = -1/500.0f;
    self.containerView.layer.sublayerTransform = perspective;
    
    // add pan gesture to handle swipe
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] init];
    [pan addTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:pan];
    
    self.doorLayer.speed = 0.0f;
    
    //
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation.y";
    animation.toValue = @(-M_PI_2);
    animation.duration = 1.0f;
    [self.doorLayer addAnimation:animation forKey:nil];
    
}

- (void)pan:(UIPanGestureRecognizer *)pan
{
    CGFloat x = [pan translationInView:self.view].x;
    x /= 200;
    
    //update time offset and clamp result
    CFTimeInterval offsetTime = self.doorLayer.timeOffset;
    offsetTime = MIN(0.999, MAX(0.0, offsetTime - x));
    NSLog(@"timeoffset:(%0.2f)", offsetTime);
    self.doorLayer.timeOffset = offsetTime;
    
    // reset pan Gesture
    [pan setTranslation:CGPointZero inView:self.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
