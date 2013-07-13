//
//  RecipeCodeCell.h
//  RecipesKit
//
//  Created by Long Vinh Nguyen on 7/12/13.
//  Copyright (c) 2013 Felipe Last Marsetti. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RecipeCodeCellReuseIdentifier @"RecipeCodeCell"
#define RecipeCodeCellSegue @"RecipeCodeCellSegue"

@interface RecipeCodeCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *servingsLabel;

@end
