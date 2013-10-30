//
//  ViewController.m
//  10.1-TimingFuction
//
//  Created by VisiKard MacBook Pro on 10/30/13.
//  Copyright (c) 2013 VLong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) CALayer *colorLayer;
@property (nonatomic, strong) UIView  *colorView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // create a red layer
//    self.colorLayer = [CALayer layer];
//    self.colorLayer.frame = CGRectMake(0, 0, 100, 100);
//    self.colorLayer.position = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2);
//    self.colorLayer.backgroundColor = [UIColor redColor].CGColor;
//    [self.view.layer addSublayer:self.colorLayer];
    
    self.colorView = [[UIView alloc] init];
    self.colorView.bounds = CGRectMake(0, 0, 100, 100);
    self.colorView.center = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2);
    self.colorView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.colorView];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // configure the transaction
//    [CATransaction begin];
//    [CATransaction setAnimationDuration:1.0f];
//    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
//    
//    self.colorLayer.position = [[touches anyObject] locationInView:self.view];
//    [CATransaction commit];
    [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.colorView.center = [[touches anyObject] locationInView:self.view];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
