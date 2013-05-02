//
//  FirstViewController.h
//  MyLocations
//
//  Created by Long Vinh Nguyen on 4/28/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationDetailsViewController.h"

@interface CurrentLocationViewController : UIViewController<CLLocationManagerDelegate>

@property (nonatomic,weak) IBOutlet UILabel *messageLabel;
@property (nonatomic,weak) IBOutlet UILabel *latitudeLabel;
@property (nonatomic,weak) IBOutlet UILabel *longtitudeLabel;
@property (nonatomic,weak) IBOutlet UILabel *addressLabel;
@property (nonatomic,weak) IBOutlet UIButton *tagButton;
@property (nonatomic,weak) IBOutlet UIButton *getButton;
@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;

@end
