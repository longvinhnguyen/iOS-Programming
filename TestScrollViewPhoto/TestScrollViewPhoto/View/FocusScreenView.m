//
//  FocusScreenView.m
//  TestScrollViewPhoto
//
//  Created by VisiKard MacBook Pro on 8/15/13.
//  Copyright (c) 2013 VisiKard MacBook Pro. All rights reserved.
//

#import "FocusScreenView.h"

@implementation FocusScreenView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    UIBezierPath *squarePath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 20, 200, 200)];
    [[UIColor whiteColor] setStroke];
    CGContextSetLineWidth(context, 5.0f);
    [squarePath stroke];
    
    UIBezierPath *mainFocusPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(60, 10, 200, 30) cornerRadius:5.0f];
    [mainFocusPath appendPath:squarePath];
    
    UIBezierPath *screenPath = [UIBezierPath bezierPathWithRect:self.frame];
    [screenPath appendPath:mainFocusPath];
    screenPath.usesEvenOddFillRule = YES;
    
    CGContextSaveGState(context);
    
    [screenPath addClip];
    [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3f] setFill];
    [screenPath fill];
    
    CGContextRestoreGState(context);
//    [[UIColor redColor] setFill];
//    CGContextFillPath(context);
    
    UIGraphicsEndImageContext();
}


@end
