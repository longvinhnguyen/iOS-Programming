//
//  BTThemeTableViewCell.m
//  AppearanceChapter
//
//  Created by Adam Burkepile on 7/21/12.
//  Copyright (c) 2012 Adam Burkepile. All rights reserved.
//

#import "BTThemeTableViewCell.h"
#import "BTTheme.h"

@implementation BTThemeTableViewCell

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

+ (Class)layerClass
{
    return [[BTThemeManager sharedTheme] gradientLayer];
}

@end
