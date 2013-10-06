//
//  ViewController.m
//  6.1-CAShapeLayer
//
//  Created by Long Vinh Nguyen on 10/6/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // create path
//    UIBezierPath *path = [[UIBezierPath alloc] init];
//    [path moveToPoint:CGPointMake(175, 100)];
//    [path addArcWithCenter:CGPointMake(150, 100) radius:25 startAngle:0 endAngle:2 * M_PI clockwise:YES];
//    [path moveToPoint:CGPointMake(150, 125)];
//    [path addLineToPoint:CGPointMake(150, 175)];
//    [path addLineToPoint:CGPointMake(175, 225)];
//    [path moveToPoint:CGPointMake(150, 175)];
//    [path addLineToPoint:CGPointMake(125, 225)];
//    [path moveToPoint:CGPointMake(100, 150)];
//    [path addLineToPoint:CGPointMake(200, 150)];
    
    // create shape layer
//    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
//    shapeLayer.strokeColor = [UIColor redColor].CGColor;
//    shapeLayer.fillColor = [UIColor clearColor].CGColor;
//    shapeLayer.lineWidth = 5;
//    shapeLayer.lineJoin = kCALineJoinRound;
//    shapeLayer.lineCap = kCALineCapRound;
//    shapeLayer.path = path.CGPath;
//    
//    [self.view.layer addSublayer:shapeLayer];
    
    // CATextLayer
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.frame = self.view.bounds;
    [self.view.layer addSublayer:textLayer];
    
    // set text attributes
    textLayer.foregroundColor = [UIColor blackColor].CGColor;
    textLayer.alignmentMode = kCAAlignmentJustified;
    textLayer.wrapped = YES;
    
    UIFont *font = [UIFont systemFontOfSize:15];
    
    // set layer font
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    textLayer.font = fontRef;
    textLayer.fontSize = font.pointSize;
    CGFontRelease(fontRef);
    
    // Choose some text
    NSString *text = @" Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque massa arcu, eleifend vel varius in, facilisis pulvinar leo. Nunc quis nunc at mauris pharetra condimentum ut ac neque. Nunc elementum, libero ut porttitor dictum, diam odio congue lacus, vel fringilla sapien diam at purus. Etiam suscipit pretium nunc sit amet lobortis";
    
    // set layer text
    textLayer.string = text;
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
