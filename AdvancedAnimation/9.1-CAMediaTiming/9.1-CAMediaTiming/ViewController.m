//
//  ViewController.m
//  9.1-CAMediaTiming
//
//  Created by VisiKard MacBook Pro on 10/29/13.
//  Copyright (c) 2013 VLong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, weak) IBOutlet UITextField *durationField;
@property (nonatomic, weak) IBOutlet UITextField *repeatField;
@property (nonatomic, weak) IBOutlet UIButton   *startButton;
@property (nonatomic, strong) CALayer *shipLayer;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // add the ship
    self.shipLayer = [CALayer layer];
    self.shipLayer.frame = CGRectMake(0, 0, 128, 128);
    self.shipLayer.position = CGPointMake(150, 150);
    self.shipLayer.contents = (__bridge id)[UIImage imageNamed:@"Ship.png"].CGImage;
    [self.containerView.layer addSublayer:self.shipLayer];
}

- (void)setControlEnabled:(BOOL)enabled
{
    for (UIControl *control in @[self.durationField, self.repeatField, self.startButton]) {
        control.enabled = enabled;
        control.alpha = enabled? 1.0f:0.25f;
    }
}

- (IBAction)hideKeyboard:(id)sender
{
    [self.durationField resignFirstResponder];
    [self.repeatField resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *anyTouch = [touches anyObject];
    if (anyTouch.tapCount == 1) {
        [self hideKeyboard:nil];
    }
}

- (IBAction)start
{
    CFTimeInterval duration = [self.durationField.text doubleValue];
    float repeatCount = [self.repeatField.text floatValue];
    
    // animate the ship rotation
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation";
    animation.duration = duration;
    animation.repeatCount = repeatCount;
    animation.byValue = @(M_PI * 2);
    animation.delegate = self;
    animation.autoreverses = YES;
    [self.shipLayer addAnimation:animation forKey:@"rotateAnimation"];
    
    // disabled controls
    [self setControlEnabled:NO];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self setControlEnabled:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
