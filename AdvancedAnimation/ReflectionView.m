//
//  ReflectionView.m
//  6.8-CAReplicatorLayer
//
//  Created by Long Vinh Nguyen on 10/11/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "ReflectionView.h"

@implementation ReflectionView

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
    return [CAReplicatorLayer class];
}

- (void)setUp
{
    CAReplicatorLayer *layer = (CAReplicatorLayer *)self.layer;
    layer.instanceCount = 2.0f;
    
    // move reflection istance below original and flip vertically
    CATransform3D transform = CATransform3DIdentity;
    CGFloat verticalOffset = self.bounds.size.height + 2;
    transform = CATransform3DTranslate(transform, 0, verticalOffset, 0);
    transform = CATransform3DScale(transform, 0.8, -1, 1);
    layer.instanceTransform = transform;
    
    layer.instanceAlphaOffset = -0.6;
    
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
