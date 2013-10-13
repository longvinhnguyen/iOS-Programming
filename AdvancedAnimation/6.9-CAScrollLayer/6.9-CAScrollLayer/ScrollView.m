//
//  ScrollView.m
//  6.9-CAScrollLayer
//
//  Created by Long Vinh Nguyen on 10/13/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "ScrollView.h"

@implementation ScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setUp];
}

+ (Class)layerClass
{
    return [CAScrollLayer class];
}

- (void)setUp
{
    self.layer.masksToBounds = YES;
    
    // attach pan gesture recognizer
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:panRecognizer];
}

- (void)pan:(UIPanGestureRecognizer *)gesture
{
    // get the offset by translating the pan gesture
    // translation from the current bounds origin
    CGPoint offset = self.bounds.origin;
    offset.x -= [gesture translationInView:self].x;
    offset.y -= [gesture translationInView:self].y;
    
    [self.layer scrollPoint:offset];
    [gesture setTranslation:CGPointZero inView:self];
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
