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

float quadraticEaseInOut(float t)
{
    return (t < 0.5)? (2 * t * t) : (-2 * t * t) + (4 * t) -1;
}

float bounceEaseOut(float t)
{
    if (t < 4/11.0) {
        return (121 * t * t)/ 16.0;
    } else if (t < 8/11.0) {
        return (363/40.0f * t * t) - (99/10.0 * t * t) + 17/5.0;
    } else if (t < 9/10.0) {
        return (4356/361.0 * t * t) - (35442/1805.0 * t) + 16061/1805.0;
    }
    return (54/5.0 * t * t) - (513/25.0 * t) + 268/25.0;
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
    for (int i = 0; i < numFrames; i++) {
        float time = 1/(float)numFrames * i;
        
        // apply easing
        time = bounceEaseOut(time);
        
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self animate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
