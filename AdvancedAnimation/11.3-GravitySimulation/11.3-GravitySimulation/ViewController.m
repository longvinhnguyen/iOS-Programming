//
//  ViewController.m
//  11.3-GravitySimulation
//
//  Created by VisiKard MacBook Pro on 11/4/13.
//  Copyright (c) 2013 VLong. All rights reserved.
//

#import "ViewController.h"
#import "Crate.h"
#import "chipmunk.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, assign) cpSpace *space;
@property (nonatomic, strong) CADisplayLink *timer;
@property (nonatomic, assign) CFTimeInterval lastStep;

@end

@implementation ViewController

#define GRAVITY 1000

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // invert view coordinate system to match physics
    self.containerView.layer.geometryFlipped = YES;
    
    // set physics space
    self.space = cpSpaceNew();
    cpSpaceSetGravity(self.space, cpv(0, -GRAVITY));
    
    // add a Crate
    Crate *crate = [[Crate alloc] initWithFrame:CGRectMake(100, 0, 100, 100)];
    [self.containerView addSubview:crate];
    cpSpaceAddBody(self.space, crate.body);
    cpSpaceAddShape(self.space, crate.shape);
    
    // start the timer
    self.lastStep = CACurrentMediaTime();
    self.timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(step:)];
    [self.timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

void updateShape(cpShape *shape, void *unused)
{
    // get the crate object associate with the shape
    Crate *crate = (__bridge Crate *)shape->data;
    cpBody *body = shape->body;
    crate.center = cpBodyGetPos(body);
    crate.transform = CGAffineTransformMakeRotation(cpBodyGetAngle(body));
}

- (void)step: (CADisplayLink *)timer
{
    // calculate step duration
    CFTimeInterval thisStep = CACurrentMediaTime();
    CFTimeInterval stepDuration = thisStep - self.lastStep;
    self.lastStep = thisStep;
    
    // update physics
    cpSpaceStep(self.space, stepDuration);
    // update all the shape
    cpSpaceEachShape(self.space, &updateShape, NULL);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
