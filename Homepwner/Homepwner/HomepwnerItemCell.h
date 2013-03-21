//
//  HomepwnerItemCell.h
//  Homepwner
//
//  Created by Long Vinh Nguyen on 2/2/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomepwnerItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) id controller;
@property (weak, nonatomic) UITableView *tableView;

- (IBAction)showImage:(id)sender;



@end
