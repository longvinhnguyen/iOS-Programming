//
//  Icon.h
//  TestScrollViewPhoto
//
//  Created by VisiKard MacBook Pro on 7/12/13.
//  Copyright (c) 2013 VisiKard MacBook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Icon : UIView

@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic, weak) IBOutlet UIImageView *plusImageView;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) UIImage *image;

@end
