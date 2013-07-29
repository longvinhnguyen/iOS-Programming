//
//  FeedCell.m
//  TestScrollViewPhoto
//
//  Created by VisiKard MacBook Pro on 7/29/13.
//  Copyright (c) 2013 VisiKard MacBook Pro. All rights reserved.
//

#import "FeedCell.h"

@implementation FeedCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize messageSize = [self.eventMessage.text sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(280, 40)];
    self.eventMessage.frame = CGRectMake(8, 0, messageSize.width, messageSize.height);
    
    CGSize likeLabelSize = [_numberLikes.text sizeWithFont:[UIFont systemFontOfSize:14]];
    _numberLikes.frame = CGRectMake(_numberLikes.frame.origin.x, _numberLikes.frame.origin.y, likeLabelSize.width, likeLabelSize.height);
    _heartIcon.frame = CGRectMake(_numberLikes.frame.origin.x  + likeLabelSize.width, _heartIcon.frame.origin.y, _heartIcon.frame.size.width, _heartIcon.frame.size.height);
    
    CGSize commentLabelSize = [_numberComments.text sizeWithFont:[UIFont systemFontOfSize:14]];
    _numberComments.frame = CGRectMake(_heartIcon.frame.origin.x + 20, _numberComments.frame.origin.y, commentLabelSize.width, commentLabelSize.height);
    _commentIcon.frame = CGRectMake(_numberComments.frame.origin.x  + commentLabelSize.width, _commentIcon.frame.origin.y, _commentIcon.frame.size.width, _commentIcon.frame.size.height);
    
    int numberOfLikes = [_numberLikes.text integerValue];
    int numberOfComments = [_numberComments.text integerValue];
    
    if (numberOfLikes > 0) {
        _heartIcon.image = [UIImage imageNamed:@"red_heart"];
    } else _heartIcon.image = [UIImage imageNamed:@"white_heart"];
    
    if (numberOfComments > 0) {
        _commentIcon.image = [UIImage imageNamed:@"comments"];
    } else _commentIcon.image = [UIImage imageNamed:@"white_comments"];
}


@end
