//
//  ViewController.m
//  2.3
//
//  Created by VisiKard MacBook Pro on 9/30/13.
//  Copyright (c) 2013 VLong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)addStrectchableImage:(UIImage *)image withContentRect:(CGRect)rect toLayer:(CALayer *)layer
{
    // setImage
    layer.contents = (__bridge id)image.CGImage;
    layer.contentsCenter = rect;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // load Button Image
    UIImage *image = [UIImage imageNamed:@"button"];
    
    [self addStrectchableImage:image withContentRect:CGRectMake(0.25, 0.25, 0.5, 0.5) toLayer:self.button1.layer];
    [self addStrectchableImage:image withContentRect:CGRectMake(0.25, 0.25, 0.5, 0.5) toLayer:self.button2.layer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
