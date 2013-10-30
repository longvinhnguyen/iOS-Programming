//
//  ViewController.m
//  10.4-TimingFunctionBezierCurve
//
//  Created by VisiKard MacBook Pro on 10/30/13.
//  Copyright (c) 2013 VLong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UIView *layerView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // create timing function
//    CAMediaTimingFunction *timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    CAMediaTimingFunction *timingFunction = [CAMediaTimingFunction functionWithControlPoints:1 :0 :0.75 :1];
    CGPoint controlPoint1, controlPoint2;
    [timingFunction getControlPointAtIndex:1 values:(float *)&controlPoint1];
    [timingFunction getControlPointAtIndex:2 values:(float *)&controlPoint2];
    
    // create curve
    UIBezierPath *curvePath = [UIBezierPath bezierPath];
    [curvePath moveToPoint:CGPointZero];
    [curvePath addCurveToPoint:CGPointMake(1, 1) controlPoint1:controlPoint1 controlPoint2:controlPoint2];
    
    [curvePath applyTransform:CGAffineTransformMakeScale(200, 200)];
    
    // create shape layer
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 4.0f;
    shapeLayer.path = curvePath.CGPath;
    
    [self.layerView.layer addSublayer:shapeLayer];
    
    self.layerView.layer.geometryFlipped = YES;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
