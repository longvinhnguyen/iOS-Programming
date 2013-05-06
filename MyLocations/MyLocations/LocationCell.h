//
//  LocationCell.h
//  MyLocations
//
//  Created by Long Vinh Nguyen on 5/1/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UILabel *descriptionLabel;
@property (nonatomic,weak) IBOutlet UILabel *addressLabel;
@property (nonatomic,weak) IBOutlet UIImageView* thumbnailView;

@end
