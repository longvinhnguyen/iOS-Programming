//
//  Common.h
//  CoolButton
//
//  Created by Long Vinh Nguyen on 4/22/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

CGMutablePathRef createRoundedRectForRect(CGRect rect, CGFloat radius);

void drawLinearGradient (CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor);

void drawGlossAndGradient (CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor);