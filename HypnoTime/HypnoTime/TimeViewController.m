//
//  TimeViewController.m
//  HypnoTime
//
//  Created by Long Vinh Nguyen on 1/27/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import "TimeViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation TimeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSBundle *appBundle = [NSBundle mainBundle];
    self = [super initWithNibName:@"TimeViewController" bundle:appBundle];
    if (self) {
        // Get the tab bar item
        UITabBarItem *tbi = [self tabBarItem];
        
        // Give it a label
        [tbi setTitle:@"Time"];
        
        UIImage *i = [UIImage imageNamed:@"Hypno.png"];
        [tbi setImage:i];
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"CurrentTimeViewController will appear");
    [super viewWillAppear:animated];
    [self showCurrentTime:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"CurrentTimeViewController will Disappear");
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self slideTimeButton];
}


- (void)showCurrentTime:(id)sender
{
    NSDate *now = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    
    [timeLabel setText:[formatter stringFromDate:now]];
    //[self spinTimeLabel];
    [self bounceTimeLabel];
    
}

- (void)spinTimeLabel
{
    // Create a basic animation
    CABasicAnimation *spin = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    [spin setToValue:[NSNumber numberWithFloat:M_PI *2]];
    [spin setDuration:1.0];
    
    // Set the timing function
    CAMediaTimingFunction *tf  = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [spin setTimingFunction:tf];
    [spin setDelegate:self];
    
    
    // Kick off the animation by adding it tot eh layer
    [[timeLabel layer] addAnimation:spin forKey:@"spinAnimation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    CAKeyframeAnimation *fade = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    [fade setValues: [NSArray arrayWithObjects:[NSNumber numberWithFloat:1.0], [NSNumber numberWithFloat:0.25], [NSNumber numberWithFloat:0.5], [NSNumber numberWithFloat:0.75], nil]];
    [fade setDuration:6.0];
    CAMediaTimingFunction *tf = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [fade setTimingFunction:tf];
    [fade setAutoreverses:YES];
    [fade setRepeatCount:HUGE_VALF];
    [[timeButton layer] addAnimation:fade forKey:@"fadeButton"];
}


- (void)bounceTimeLabel
{
    // Create a key frame animation
    CAKeyframeAnimation *bounce = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    // Bronze Challenge: More animation
    CAKeyframeAnimation *fade = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    
    // Create the values it will pass through
    CATransform3D forward = CATransform3DMakeScale(1.3, 1.3, 1);
    CATransform3D back = CATransform3DMakeScale(0.7, 0.7, 1);
    CATransform3D forward2 = CATransform3DMakeScale(1.2, 1.2, 1);
    CATransform3D back2 = CATransform3DMakeScale(0.9, 0.9, 1);
    [bounce setValues:[NSArray arrayWithObjects:[NSValue valueWithCATransform3D:forward],[NSValue valueWithCATransform3D:back], [NSValue valueWithCATransform3D:forward2], [NSValue valueWithCATransform3D:back2], nil]];
    [fade setValues: [NSArray arrayWithObjects:[NSNumber numberWithFloat:1.0], [NSNumber numberWithFloat:0.75], [NSNumber numberWithFloat:0.5], [NSNumber numberWithFloat:0.25], nil]];
    
    // Set the duration
    [bounce setDuration:6.0];
    [fade setDuration:6.0];
    
    CAMediaTimingFunction *tf = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [bounce setTimingFunction:tf];
    [fade setTimingFunction:tf];
    
    // Animate the layer
    [[timeLabel layer] addAnimation:bounce forKey:@"bounceAnimation"];
    [[timeLabel layer] addAnimation:fade forKey:@"fadeAnimation"];    
}


// Silver Challenge: Even More Animation
- (void)slideTimeButton
{
    CABasicAnimation *slide = [CABasicAnimation animationWithKeyPath:@"position"];
    CGPoint fromValue = CGPointMake(0.0, [timeButton center].y);
    CGPoint toValue = timeButton.center;
    [slide setFromValue:[NSValue valueWithCGPoint:fromValue]];
    [slide setToValue:[NSValue valueWithCGPoint:toValue]];
    [slide setDuration:1.0];
    CAMediaTimingFunction *tf = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [slide setTimingFunction:tf];
    [slide setDelegate:self];
    
    [[timeButton layer] addAnimation:slide forKey:@"slidingButton"];
}








@end
