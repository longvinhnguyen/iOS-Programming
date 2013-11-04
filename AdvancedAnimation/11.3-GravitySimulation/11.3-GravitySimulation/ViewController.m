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

#define SIMULATION_STEP (1/120.0)

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
    
    // add wall around edge of view
    [self addWallShapeWithStart:cpv(0, 0) end:cpv(300, 0)];
    [self addWallShapeWithStart:cpv(300, 0) end:cpv(300, 320)];
    [self addWallShapeWithStart:cpv(300, 320) end:cpv(0, 320)];
    [self addWallShapeWithStart:cpv(0, 320) end:cpv(0, 0)];
    
    
    
    // add a Crates
    [self addCrateWithFrame:CGRectMake(0, 0, 32, 32)];
    [self addCrateWithFrame:CGRectMake(32, 0, 32, 32)];
    [self addCrateWithFrame:CGRectMake(64, 0, 64, 64)];
    [self addCrateWithFrame:CGRectMake(128, 0, 32, 32)];
    [self addCrateWithFrame:CGRectMake(0, 32, 64, 64)];
    
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
//    CFTimeInterval thisStep = CACurrentMediaTime();
//    CFTimeInterval stepDuration = thisStep - self.lastStep;
//    self.lastStep = thisStep;
    
    CFTimeInterval frameTime = CACurrentMediaTime();
    
    // update simulation
    while (self.lastStep < frameTime) {
        cpSpaceStep(self.space, SIMULATION_STEP);
        self.lastStep += SIMULATION_STEP;
    }
    
    // update all the shape
    cpSpaceEachShape(self.space, &updateShape, NULL);
}

- (void)addCrateWithFrame:(CGRect)frame
{
    Crate *crate = [[Crate alloc] initWithFrame:frame];
    [self.containerView addSubview:crate];
    cpSpaceAddBody(self.space, crate.body);
    cpSpaceAddShape(self.space, crate.shape);
}

- (void)addWallShapeWithStart:(cpVect)start end:(cpVect)end
{
    cpShape *wall = cpSegmentShapeNew(self.space->staticBody, start, end, 1);
    cpShapeSetCollisionType(wall, 2);
    cpShapeSetFriction(wall, 0.5);
    cpShapeSetElasticity(wall, 0.8);
    cpSpaceAddStaticShape(self.space, wall);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
