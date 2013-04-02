//
//  DragViewGesture.m
//  DragView
//
//  Created by Long Vinh Nguyen on 4/1/13.
//  Copyright (c) 2013 home.vn. All rights reserved.
//

#import "DragViewGesture.h"

@implementation DragViewGesture

- (id)initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
    if (self) {
        self.userInteractionEnabled = YES;
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self setGestureRecognizers:@[panRecognizer]];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Promote the touched view
    [self.superview bringSubviewToFront:self];
    
    // Remember original location
    previousLocation = self.center;
    
}

- (void)handlePan: (UIPanGestureRecognizer *) uigr
{
    CGPoint translation = [uigr translationInView:self];
    NSLog(@"translation point superview: %f %f",translation.x, translation.y);
    NSLog(@"translation point view: %f %f", [uigr translationInView:self].x, [uigr translationInView:self].y);
    self.center = CGPointMake(previousLocation.x + translation.x, previousLocation.y +translation.y);
}

@end
