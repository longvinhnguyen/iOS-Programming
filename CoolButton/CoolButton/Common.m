//
//  Common.m
//  CoolButton
//
//  Created by Long Vinh Nguyen on 4/22/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "Common.h"

CGMutablePathRef createRoundedRectForRect(CGRect rect, CGFloat radius)
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMaxY(rect), radius);
    CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect), CGRectGetMaxY(rect), radius);
    CGPathAddArcToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect), CGRectGetMinY(rect), radius);
    CGPathAddArcToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetMidX(rect), CGRectGetMinY(rect), radius);
    CGPathCloseSubpath(path);
    
    return path;
}

void drawLinearGradient (CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor)
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    CGFloat locations[] = {0.0, 1.0};
    NSArray *colors = @[(__bridge id)startColor, (__bridge id)endColor];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, locations);
    
    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGColorSpaceRelease(colorSpace);
   
    CFRelease(gradient);
}

void drawGlossAndGradient (CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor)
{
    drawLinearGradient(context, rect, startColor, endColor);
    
    CGRect topHalf = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height / 2);
    UIColor *gloss1 = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.35];
    UIColor *gloss2 = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.1];
    
    drawLinearGradient(context, topHalf, gloss1.CGColor, gloss2.CGColor);
}











