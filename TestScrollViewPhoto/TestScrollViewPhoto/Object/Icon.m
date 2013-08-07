//
//  Icon.m
//  TestScrollViewPhoto
//
//  Created by VisiKard MacBook Pro on 7/12/13.
//  Copyright (c) 2013 VisiKard MacBook Pro. All rights reserved.
//

#import "Icon.h"
#import <QuartzCore/QuartzCore.h>

@interface Icon()


@end

@implementation Icon

- (id)init
{
    self =[[NSBundle mainBundle] loadNibNamed:@"Icon" owner:nil options:nil][0];
    if (self) {
        self.iconImageView.layer.cornerRadius = 10;
        self.iconImageView.layer.masksToBounds = YES;
        self.iconImageView.layer.opacity = 0.6;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (UIImage *)image
{
    return self.iconImageView.image;
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
