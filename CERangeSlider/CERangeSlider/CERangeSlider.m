//
//  CERangeSlider.m
//  CERangeSlider
//
//  Created by VisiKard MacBook Pro on 5/31/13.
//  Copyright (c) 2013 VisiKard MacBook Pro. All rights reserved.
//

#import "CERangeSlider.h"
#import <QuartzCore/QuartzCore.h>

@implementation CERangeSlider
{
    CALayer *_trackLayer;
    CALayer *_upperKnobLayer;
    CALayer *_lowerKnobLayer;
    
    float _knobWidth;
    float _usableTrackLength;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _maximumValue = 10.0;
        _minimumValue = 0.0;
        _upperValue = 8.0;
        _lowerValue = 2.0;
        
        _trackLayer = [CALayer layer];
        _trackLayer.backgroundColor = [UIColor blueColor].CGColor;
        [self.layer addSublayer:_trackLayer];
        
        _upperKnobLayer = [CALayer layer];
        _upperKnobLayer.backgroundColor = [UIColor greenColor].CGColor;
        [self.layer addSublayer:_upperKnobLayer];
        
        _lowerKnobLayer = [CALayer layer];
        _lowerKnobLayer.backgroundColor = [UIColor greenColor].CGColor;
        [self.layer addSublayer:_lowerKnobLayer];
        
        [self setLayerFrames];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setLayerFrames
{
    
}

@end
