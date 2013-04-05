//
//  FlickrPhotoCell.m
//  FlickSearch
//
//  Created by Long Vinh Nguyen on 4/4/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "FlickrPhotoCell.h"
#import "FlickrPhoto.h"
#import <QuartzCore/QuartzCore.h>

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

- (void)setSelected:(BOOL)selected
{
    if (selected) {
        NSLog(@"%s %d", __PRETTY_FUNCTION__, __LINE__);
        UIView *bgView = [[UIView alloc] initWithFrame:self.backgroundView.frame];
        bgView.backgroundColor = [UIColor blueColor];
        bgView.layer.borderColor = [[UIColor whiteColor] CGColor];
        bgView.layer.borderWidth = 4;
        
        // [self setBackgroundColor:[UIColor blueColor]];
        [self setBackgroundColor:[UIColor clearColor]];
        [self setBackgroundView:bgView];
    } else
        [self setBackgroundView:nil];
        [self setBackgroundColor:[UIColor whiteColor]];
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
