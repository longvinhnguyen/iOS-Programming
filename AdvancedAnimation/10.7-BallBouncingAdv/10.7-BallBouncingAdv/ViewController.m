//
//  ViewController.m
//  10.7-BallBouncingAdv
//
//  Created by VisiKard MacBook Pro on 10/30/13.
//  Copyright (c) 2013 VLong. All rights reserved.
//

#import "ViewController.h"

float interpolate(float from, float to, float time) {
    return (to - from) * time + from;
}

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, strong) UIImageView *ballView;

@end

@implementation ViewController

- (id)interpolateFromValue:(id)fromValue toValue:(id)toValue time:(float)time
{
    // get type
    if ([fromValue isKindOfClass:[NSValue class]]) {
        const char *type = [fromValue objCType];
        if (strcmp(type, @encode(CGPoint)) == 0) {
            CGPoint from = [fromValue CGPointValue];
            CGPoint to = [toValue CGPointValue];
            CGPoint result = CGPointMake(interpolate(from.x, to.x, time), interpolate(from.y, to.y, time));
            return [NSValue valueWithCGPoint:result];
        }
    }
    return time < 0.5?fromValue:toValue;
}

- (void)animate
{
    // reset ball position
    self.ballView.center = CGPointMake(150, 32);
    
    //
    NSValue *fromValue = [NSValue valueWithCGPoint:CGPointMake(150, 32)];
    NSValue *toValue = [NSValue valueWithCGPoint:CGPointMake(150, 268)];
    CFTimeInterval duration = 1.0f;
    
    // generate keyframes
    NSInteger numFrames = duration * 60;
    NSMutableArray *frames = [NSMutableArray array];
    for (int i = 0; i <= numFrames; i++) {
        float time = 1/(float)numFrames * i;
        NSLog(@"time %f", time);
        [frames addObject:[self interpolateFromValue:fromValue toValue:toValue time:time]];
    }

    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.delegate = self;
    animation.duration = 1.0;
    animation.values = frames;

    // apply animation
    [self.ballView.layer addAnimation:animation forKey:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageNamed:@"Ball.png"];
    self.ballView = [[UIImageView alloc] initWithImage:image];
    [self.containerView addSubview:self.ballView];
    [self animate];
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    [self animate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
