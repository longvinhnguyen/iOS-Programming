//
//  RecipeCell.m
//  RecipesKit
//
//  Created by Long Vinh Nguyen on 7/12/13.
//  Copyright (c) 2013 Felipe Last Marsetti. All rights reserved.
//

#import "RecipeCell.h"

@implementation RecipeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
