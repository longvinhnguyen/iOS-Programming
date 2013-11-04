//
//  Crate.m
//  11.3-GravitySimulation
//
//  Created by VisiKard MacBook Pro on 11/4/13.
//  Copyright (c) 2013 VLong. All rights reserved.
//

#import "Crate.h"
#import "ViewController.h"

@interface Crate()

@end

@implementation Crate

#define MASS 100

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // set image
        self.image = [UIImage imageNamed:@"Crate.png"];
        self.contentMode = UIViewContentModeScaleAspectFill;
        
        self.body = cpBodyNew(MASS, cpMomentForBox(MASS, frame.size.width, frame.size.height));
        
        // create the shape
        cpVect corners[] = {
            cpv(0, 0), cpv(0, frame.size.height), cpv(frame.size.width, frame.size.height), cpv(frame.size.width, 0)
        };
        
        self.shape = cpPolyShapeNew(self.body, 4, corners, cpv(-frame.size.width / 2, -frame.size.height/ 2));
        
        // set shape friction & elasticity
        cpShapeSetFriction(self.shape, 0.5);
        cpShapeSetElasticity(self.shape, 0.8);
        
        // link the crate to the shape
        self.shape -> data = (__bridge void *)self;
        
        // set the body position to match view
        cpBodySetPos(self.body, cpv(frame.origin.x + frame.size.width / 2, 300 - frame.origin.y - frame.size.height / 2));
    }
    return self;
}

- (void)dealloc
{
    // release the shape and body
    cpShapeFree(self.shape);
    cpBodyFree(self.body);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
