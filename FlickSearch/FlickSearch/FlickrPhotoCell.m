//
//  FlickrPhotoCell.m
//  FlickSearch
//
//  Created by Long Vinh Nguyen on 4/4/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "FlickrPhotoCell.h"
#import "FlickrPhoto.h"

@implementation FlickrPhotoCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setPhoto:(FlickrPhoto *)photo
{
    if (_photo != photo) {
        _photo = photo;
    }
    [self.imageView setImage:_photo.thumbnail];
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
