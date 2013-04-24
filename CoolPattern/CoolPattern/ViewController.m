//
//  ViewController.m
//  CoolPattern
//
//  Created by Long Vinh Nguyen on 4/23/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIScrollView *scrollView = (UIScrollView *)self.view;
    UIView *patternView = (UIView *)([self.view subviews][0]);
    NSLog(@"Height of pattern view: %f", patternView.bounds.size.height);
    [scrollView setContentSize:CGSizeMake(self.view.bounds.size.width,  patternView.bounds.size.height - 400)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
