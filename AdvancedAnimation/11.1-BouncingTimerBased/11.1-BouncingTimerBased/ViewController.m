//
//  ViewController.m
//  11.1-BouncingTimerBased
//
//  Created by VisiKard MacBook Pro on 11/1/13.
//  Copyright (c) 2013 VLong. All rights reserved.
//

#import "ViewController.h"

float interpolate (float from, float to, float time)
{
    return (to - from) * time + to;
}

float bounceEaseOut( float t) {
    if (t < 4/ 11.0){
        return (121 * t * t)/ 16.0;
    } else if (t < 8/ 11.0) {
        return (363/ 40.0 * t * t) - (99/ 10.0 * t) + 17/ 5.0;
    } else if (t < 9/ 10.0){
        return (4356/ 361.0 * t * t) - (35442/ 1805.0 * t) + 16061/ 1805.0;
    }
    return (54/ 5.0 * t * t) - (513/ 25.0 * t) + 268/ 25.0;
}

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, strong) UIImageView *ballView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) NSTimeInterval timeOffset;
@property (nonatomic, strong) id fromValue;
@property (nonatomic, strong) id toValue;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // add ball image view
    UIImage *image = [UIImage imageNamed:@"Ball.png"];
    UIImageView *ballView = [[UIImageView alloc] initWithImage:image];
    [self.containerView addSubview:ballView];
    
    // animate
    [self animate];
}

- (id)interpolateFromValue:(id)fromValue toValue:(id)toValue time:(float)time
{
    if ([fromValue isKindOfClass:[NSValue class]]) {
        // get type
        const char *type = [(NSValue *)fromValue objCType];
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
    // reset ball to top screen
    self.ballView.center = CGPointMake(150, 32);
    
    // configure the animation
    self.duration = 1.0f;
    self.timeOffset = 0.0;
    self.fromValue = [NSValue valueWithCGPoint:CGPointMake(150, 32)];
    self.toValue = [NSValue valueWithCGPoint:CGPointMake(150, 268)];
    
    // stop timer if it's already running
    [self.timer invalidate];
    
    // start the timer
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1/60.0 target:self selector:@selector(step:) userInfo:nil repeats:YES];
}

- (void)step:(NSTimer *)timer
{
    // update time offset
    self.timeOffset = MIN(self.timeOffset + 1/60.0, self.duration);
    
    // get normalized the time offset
    float time = self.timeOffset / self.duration;
    
    // apply easing
    time = bounceEaseOut(time);
    
    // interpolate position
    id  position = [self interpolateFromValue:self.fromValue toValue:self.toValue time:time];
    
    // move ball to new position
    self.ballView.center = [position CGPointValue];
    
    if (self.timeOffset >= self.duration) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self animate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
