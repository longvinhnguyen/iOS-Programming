//
//  DragView.m
//  DragView
//
//  Created by Long Vinh Nguyen on 4/1/13.
//  Copyright (c) 2013 home.vn. All rights reserved.
//

#import "DragView.h"

@implementation DragView


- (id)initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Calculation and store offset, and pop view into front if needed
    startLocation = [[touches anyObject] locationInView:self];
    // startLocation = self.center;
    [self.superview bringSubviewToFront:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Calculate offset
    CGPoint pt = [[touches anyObject] locationInView:self];
    float dx = pt.x - startLocation.x;
    float dy = pt.y - startLocation.y;
    CGPoint newcenter = CGPointMake(self.center.x + dx, self.center.y + dy);
    
    // Set new location
    self.center = newcenter;
}


@end
