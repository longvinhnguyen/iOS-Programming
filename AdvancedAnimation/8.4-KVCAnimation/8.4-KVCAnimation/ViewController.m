//
//  ViewController.m
//  8.4-KVCAnimation
//
//  Created by Long Vinh Nguyen on 10/17/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UIImageView  *hourHand;
@property (nonatomic, weak) IBOutlet UIImageView  *minuteHand;
@property (nonatomic, weak) IBOutlet UIImageView  *secondHand;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.hourHand.layer.anchorPoint = CGPointMake(0.5f, 0.9f);
//    self.minuteHand.layer.anchorPoint = CGPointMake(0.5f, 0.9f);
//    self.secondHand.layer.anchorPoint = CGPointMake(0.5f, 0.9f);
    
    // start timer
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(tick) userInfo:nil repeats:YES];
    [self updateHandAnimated:NO];
}

- (void)tick
{
    [self updateHandAnimated:YES];
}

- (void)updateHandAnimated:(BOOL)animated
{
    // convert time to hours, minutes and seconds
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSUInteger units = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *components = [calendar components:units fromDate:[NSDate date]];
    
    // calculate hour and angle
    CGFloat hourAngle = (components.hour / 12.0) * M_PI * 2;
    CGFloat minuteAngle = (components.minute / 60.0) * M_PI * 2;
    CGFloat secondAngle = (components.second / 60.0) * M_PI * 2;
    
    // rotate hands
    [self setAngle:hourAngle forHand:self.hourHand animated:animated];
    [self setAngle:minuteAngle forHand:self.minuteHand animated:animated];
    [self setAngle:secondAngle forHand:self.secondHand animated:animated];
}

- (void)setAngle:(CGFloat)angle forHand:(UIView *)handView animated:(BOOL)animated
{
    // generate form
    CATransform3D transform = CATransform3DMakeRotation(angle, 0, 0, 1);
    if (animated) {
        // Create transform animation
        CABasicAnimation *animation = [CABasicAnimation animation];
        animation.keyPath = @"transform";
        animation.toValue = [NSValue valueWithCATransform3D:transform];
        animation.duration = 0.5f;
        animation.delegate = self;
        
        // update with timing function chapter 10
        CAMediaTimingFunction *timingFunction = [CAMediaTimingFunction functionWithControlPoints:1 :0 :0.75 :1];
        animation.timingFunction = timingFunction;
        
        [animation setValue:handView forKey:@"handView"];
        [handView.layer addAnimation:animation forKey:nil];
    } else {
        handView.layer.transform = transform;
    }
}

- (void)animationDidStop:(CABasicAnimation *)anim finished:(BOOL)flag
{
    UIView *handView = [anim valueForKey:@"handView"];
    handView.layer.transform = [anim.toValue CATransform3DValue];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
