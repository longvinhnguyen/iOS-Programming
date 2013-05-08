//
//  SearchResultCell.h
//  StoreSearch
//
//  Created by Long Vinh Nguyen on 5/8/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UILabel *nameLabel;
@property (nonatomic,weak) IBOutlet UILabel *artistNameLabel;
@property (nonatomic,weak) IBOutlet UIImageView *artworkImageView;


@end
