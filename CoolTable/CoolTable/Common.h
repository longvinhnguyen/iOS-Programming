//
//  Common.h
//  CoolTable
//
//  Created by Long Vinh Nguyen on 4/20/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

static inline double radians (double degrees) {return degrees * (M_PI/180);}

void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor);

void draw1PxStroke(CGContextRef context, CGPoint startPoint, CGPoint endPoint, CGColorRef color);

CGRect rectFor1PxStroke(CGRect rect);

CGMutablePathRef createArcPathFromBottomOfRect(CGRect rect, CGFloat arcHeight);