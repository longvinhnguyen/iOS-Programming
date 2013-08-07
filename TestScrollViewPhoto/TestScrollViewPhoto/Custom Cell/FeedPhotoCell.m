//
//  FeedPhotoCell.m
//  TestScrollViewPhoto
//
//  Created by VisiKard MacBook Pro on 7/29/13.
//  Copyright (c) 2013 VisiKard MacBook Pro. All rights reserved.
//

#import "FeedPhotoCell.h"

@implementation FeedPhotoCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize messageSize = [self.eventMessage.text sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(280, 40)];
    self.eventMessage.frame = CGRectMake(8, 0, messageSize.width, messageSize.height);
    
    self.photo.frame = CGRectMake(self.eventMessage.frame.origin.x, self.eventMessage.frame.origin.y + messageSize.height, self.photo.bounds.size.width, self.photo.bounds.size.height);
    
    CGSize likeLabelSize = [self.numberLikes.text sizeWithFont:[UIFont systemFontOfSize:14]];
    self.numberLikes.frame = CGRectMake(self.numberLikes.frame.origin.x, self.numberLikes.frame.origin.y, likeLabelSize.width, likeLabelSize.height);
    self.heartIcon.frame = CGRectMake(self.numberLikes.frame.origin.x  + likeLabelSize.width, self.heartIcon.frame.origin.y, self.heartIcon.frame.size.width, self.heartIcon.frame.size.height);
    
    CGSize commentLabelSize = [self.numberComments.text sizeWithFont:[UIFont systemFontOfSize:14]];
    self.numberComments.frame = CGRectMake(self.heartIcon.frame.origin.x + 20, self.numberComments.frame.origin.y, commentLabelSize.width, commentLabelSize.height);
    self.commentIcon.frame = CGRectMake(self.numberComments.frame.origin.x  + commentLabelSize.width, self.commentIcon.frame.origin.y, self.commentIcon.frame.size.width, self.commentIcon.frame.size.height);
    
    int numberOfLikes = [self.numberLikes.text integerValue];
    int numberOfComments = [self.numberComments.text integerValue];
    
    if (numberOfLikes > 0) {
        self.heartIcon.image = [UIImage imageNamed:@"red_heart"];
    } else self.heartIcon.image = [UIImage imageNamed:@"white_heart"];
    
    if (numberOfComments > 0) {
        self.commentIcon.image = [UIImage imageNamed:@"comments"];
    } else self.commentIcon.image = [UIImage imageNamed:@"white_comments"];
}



@end
