//
//  VenueDetailControllerViewController.h
//  APISExplorer
//
//  Created by Long Vinh Nguyen on 6/17/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Venue;

@interface VenueDetailController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *name;
@property (nonatomic, weak) IBOutlet UILabel *address;
@property (nonatomic, weak) IBOutlet UILabel *phoneNumber;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) Venue* venue;

@end
