//
//  AlbumView.m
//  BlueLibrary
//
//  Created by Long Vinh Nguyen on 9/8/13.
//  Copyright (c) 2013 Eli Ganem. All rights reserved.
//

#import "AlbumView.h"

@implementation AlbumView
{
    UIImageView *coverImage;
    UIActivityIndicatorView *indicator;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame albumCover:(NSString *)albumCover
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        coverImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, frame.size.width - 10, frame.size.height - 10)];
        [self addSubview:coverImage];
        
        indicator = [[UIActivityIndicatorView alloc] init];
        indicator.center = self.center;
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [indicator startAnimating];
        [self addSubview:indicator];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BLDownloadImageNotification" object:self userInfo:@{@"imageView": coverImage, @"coverUrl": albumCover}];
        [coverImage addObserver:self forKeyPath:@"image" options:0 context:nil];
    }
    
    return self;
}

- (void)dealloc
{
    NSLog(@"Release object %@", self);
    [coverImage removeObserver:self forKeyPath:@"image"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"image"]) {
        [indicator stopAnimating];
    }
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
