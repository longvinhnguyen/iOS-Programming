//
//  ViewController.m
//  14.7-Hybrid Image
//
//  Created by Long Vinh Nguyen on 11/15/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // load color image
    UIImage *image = [UIImage imageNamed:@"Snowman.jpg"];
    
    // load mask image
    UIImage *mask = [UIImage imageNamed:@"SnowmanMask.png"];
    
    // convert mask to correct format
    CGColorSpaceRef graySpace = CGColorSpaceCreateDeviceGray();
    CGImageRef maskRef = CGImageCreateCopyWithColorSpace(mask.CGImage, graySpace);
    CGColorSpaceRelease(graySpace);
    
    // combine images
    CGImageRef resultRef = CGImageCreateWithMask(image.CGImage, maskRef);
    UIImage *result = [UIImage imageWithCGImage:resultRef];
    CGImageRelease(resultRef);
    CGImageRelease(maskRef);
    
    // display result
    self.imageView.image = result;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
