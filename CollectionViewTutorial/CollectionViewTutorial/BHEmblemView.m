//
//  BHEmblemView.m
//  CollectionViewTutorial
//
//  Created by VisiKard MacBook Pro on 8/26/13.
//  Copyright (c) 2013 VLong. All rights reserved.
//

#import "BHEmblemView.h"

static NSString * const BHEmblemViewImageName = @"emblem";

@implementation BHEmblemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *image = [UIImage imageNamed:BHEmblemViewImageName];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = self.bounds;
        [self addSubview:imageView];
    }
    return self;
}

+ (CGSize)defaultSize
{
    return [UIImage imageNamed:BHEmblemViewImageName].size;
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
