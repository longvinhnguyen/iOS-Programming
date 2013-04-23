//
//  CoolPatternView.m
//  CoolPattern
//
//  Created by Long Vinh Nguyen on 4/23/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "CoolPatternView.h"

static inline double radians (double degrees)
{
    return degrees * M_PI/180;
}

void MyDrawColoredPattern (void *info, CGContextRef context)
{
    //
    UIColor *dotColor = [UIColor colorWithHue:0.0 saturation:0.0 brightness:0.07 alpha:1.0];
    UIColor *shadowColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.1];
    
    CGContextSetFillColorWithColor(context, dotColor.CGColor);
    CGContextSetShadowWithColor(context, CGSizeMake(0, 1), 1, shadowColor.CGColor);
    CGContextAddArc(context, 3, 3, 4, 0, radians(360), 0);
    CGContextFillPath(context);
    
    CGContextAddArc(context, 16, 16, 4, 0, radians(360), 0);
    CGContextFillPath(context);
    
    
    
}

@implementation CoolPatternView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor *bgColor = [UIColor colorWithHue:0.0 saturation:0.0 brightness:0.15 alpha:1.0];
    CGContextSetFillColorWithColor(context, bgColor.CGColor);
    CGContextFillRect(context, rect);
    
    static const CGPatternCallbacks callbacks = {0, &MyDrawColoredPattern, NULL};
    
    CGContextSaveGState(context);
    CGColorSpaceRef patternSpace = CGColorSpaceCreatePattern(NULL);
    CGContextSetFillColorSpace(context, patternSpace);
    CGColorSpaceRelease(patternSpace);
    
    CGPatternRef pattern = CGPatternCreate(NULL, rect, CGAffineTransformIdentity, 24, 24, kCGPatternTilingConstantSpacing, true, &callbacks);
    
    CGFloat alpha = 1.0;
    CGContextSetFillPattern(context, pattern, &alpha);
    CGPatternRelease(pattern);
    CGContextFillRect(context, self.bounds);
    CGContextRestoreGState(context);
    
    
    
}







@end
