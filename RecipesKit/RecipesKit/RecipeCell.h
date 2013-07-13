//
//  RecipeCell.h
//  RecipesKit
//
//  Created by Long Vinh Nguyen on 7/12/13.
//  Copyright (c) 2013 Felipe Last Marsetti. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RecipeCellReuseIdentifier @"RecipeCell"

@interface RecipeCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *subTitleLabel;

@end
