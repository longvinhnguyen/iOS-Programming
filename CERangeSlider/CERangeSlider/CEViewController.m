//
//  CEViewController.m
//  CERangeSlider
//
//  Created by VisiKard MacBook Pro on 5/31/13.
//  Copyright (c) 2013 VisiKard MacBook Pro. All rights reserved.
//

#import "CEViewController.h"
#import "CERangeSlider.h"

@interface CEViewController ()

@end

@implementation CEViewController
{
    CERangeSlider *_rangeSlider;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSUInteger margin = 20;
    CGRect sliderFrame = CGRectMake(margin, margin, self.view.frame.size.width - margin * 2, 30);
    _rangeSlider = [[CERangeSlider alloc] initWithFrame:sliderFrame];
    _rangeSlider.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:_rangeSlider];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
