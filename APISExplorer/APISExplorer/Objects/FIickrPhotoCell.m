//
//  FIickrPhotoCell.m
//  APISExplorer
//
//  Created by Long Vinh Nguyen on 6/21/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "FIickrPhotoCell.h"
#import "Photo.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@implementation FIickrPhotoCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setPhoto:(Photo *)photo
{
    _photo = photo;
    [_imageView setImageWithURL:_photo.photoURL placeholderImage:[UIImage imageNamed:@"placeholder"]];
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
