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
