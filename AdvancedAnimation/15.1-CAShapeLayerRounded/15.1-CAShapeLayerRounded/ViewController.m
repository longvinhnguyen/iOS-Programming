//
//  ViewController.m
//  15.1-CAShapeLayerRounded
//
//  Created by Long Vinh Nguyen on 11/16/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UIView *layerView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    CAShapeLayer *blueLayer = [CAShapeLayer layer];
//    blueLayer.frame = CGRectMake(50, 50, 100, 100);
//    blueLayer.fillColor = [UIColor blueColor].CGColor;
//    blueLayer.path = [UIBezierPath bezierPathWithRoundedRect:blueLayer.bounds cornerRadius:20].CGPath;
//    [self.layerView.layer addSublayer:blueLayer];
    
    CALayer *blueLayer = [CALayer layer];
    blueLayer.frame = CGRectMake(50, 50, 100, 100);
    blueLayer.contentsCenter = CGRectMake(0.5, 0.5, 0, 0);
    blueLayer.contentsScale = [UIScreen mainScreen].scale;
    blueLayer.contents = (__bridge id)[UIImage imageNamed:@"Rounded.png"].CGImage;

    // add it to our view
    [self.layerView.layer addSublayer:blueLayer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
