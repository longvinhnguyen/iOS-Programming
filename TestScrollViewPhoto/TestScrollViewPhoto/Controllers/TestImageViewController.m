//
//  TestImageViewController.m
//  TestScrollViewPhoto
//
//  Created by Long Vinh Nguyen on 9/12/13.
//  Copyright (c) 2013 VisiKard MacBook Pro. All rights reserved.
//

#import "TestImageViewController.h"

@interface TestImageViewController ()

@end

@implementation TestImageViewController
{
    CGRect portraitRect;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    portraitRect = self.imageView.frame;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)rotateButtonTapped:(id)sender
{
    NSLog(@"Before Transform Frame %f %f %f %f", self.imageView.frame.origin.x, self.imageView.frame.origin.y, self.imageView.frame.size.width, self.imageView.frame.size.height);
    self.imageView.transform = CGAffineTransformMakeRotation(- M_PI / 2);
    NSLog(@"AFter Transform Frame %f %f %f %f", self.imageView.frame.origin.x, self.imageView.frame.origin.y, self.imageView.frame.size.width, self.imageView.frame.size.height);
    self.imageView.frame = CGRectMake(0, 0, self.imageView.frame.size.width, self.imageView.frame.size.height);
    NSLog(@"Change Frame %f %f %f %f", self.imageView.frame.origin.x, self.imageView.frame.origin.y, self.imageView.frame.size.width, self.imageView.frame.size.height);
    self.imageView.image = [UIImage imageNamed:@"rex_hotel.jpg"];
}

- (IBAction)resetButton:(id)sender
{
    self.imageView.transform = CGAffineTransformIdentity;
    self.imageView.frame = portraitRect;
    NSLog(@"CGAffineTransformIdentity Transform Frame %f %f %f %f", self.imageView.frame.origin.x, self.imageView.frame.origin.y, self.imageView.frame.size.width, self.imageView.frame.size.height);
    self.imageView.image = [UIImage imageNamed:@"rex_hotel.jpg"];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    NSLog(@"Rotate view");
    NSLog(@"AFter Rotate Frame %f %f %f %f", self.imageView.frame.origin.x, self.imageView.frame.origin.y, self.imageView.frame.size.width, self.imageView.frame.size.height);
}

@end
