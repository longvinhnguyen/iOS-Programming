//
//  FlickrPhotoHeaderView.m
//  FlickSearch
//
//  Created by Long Vinh Nguyen on 4/4/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "FlickrPhotoHeaderView.h"

@implementation FlickrPhotoHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews
{
    self.searchLabel.center = CGPointMake(self.bounds.size.width / 2.0f, self.bounds.size.height / 2.0f);
    
    CGFloat bgImgWidth = self.searchLabel.bounds.size.width + 106.0f;
    self.backgroundView.frame = CGRectMake((self.bounds.size.width - bgImgWidth) / 2.0f, 0.0f, bgImgWidth, 120.0f);
}

- (void)setSearchText:(NSString *)text
{
    [self.searchLabel setText:text];
    UIImage *shareButtonImage = [[UIImage imageNamed:@"header_bg.png"] resizableImageWithCapInsets: UIEdgeInsetsMake(68, 68, 68, 68)];
    [self.backgroundView setImage:shareButtonImage];
    self.backgroundView.center = self.center;
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
