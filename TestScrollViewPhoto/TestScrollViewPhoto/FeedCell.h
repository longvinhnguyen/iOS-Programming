//
//  FeedCell.h
//  TestScrollViewPhoto
//
//  Created by VisiKard MacBook Pro on 7/29/13.
//  Copyright (c) 2013 VisiKard MacBook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *eventMessage;
@property (nonatomic, weak) IBOutlet UILabel *numberLikes;
@property (nonatomic, weak) IBOutlet UILabel *numberComments;
@property (nonatomic, weak) IBOutlet UIImageView *heartIcon;
@property (nonatomic, weak) IBOutlet UIImageView *commentIcon;

@end
