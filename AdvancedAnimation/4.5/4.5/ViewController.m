//
//  ViewController.m
//  4.5
//
//  Created by Long Vinh Nguyen on 9/30/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CALayer *maskLayer = [CALayer layer];
    UIImage *coneImage = [UIImage imageNamed:@"Cone"];
    maskLayer.frame = self.imageView.bounds;
    maskLayer.contents = (__bridge id)coneImage.CGImage;

    self.imageView.layer.mask = maskLayer;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
