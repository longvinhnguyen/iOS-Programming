//
//  HudView.h
//  MyLocations
//
//  Created by Long Vinh Nguyen on 4/30/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HudView : UIView

+ (HudView *)hudInView:(UIView *)view animated:(BOOL)animated;

@property (nonatomic,strong) NSString *text;

@end
