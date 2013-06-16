//
//  ViewController.h
//  APISExplorer
//
//  Created by Long Vinh Nguyen on 6/9/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IIViewDeckController.h>
#import "LeftMenuController.h"

@class ViewController, Venue;

@protocol ViewControllerDelegate <NSObject>

- (void)viewController:(ViewController *)controller showVenueOnMap:(Venue *)venue;

@end

@interface ViewController : UIViewController<IIViewDeckControllerDelegate, LeftMenuControllerDelegate>

@property (nonatomic, weak) IBOutlet UITableView *mainTableView;
@property (nonatomic, weak) id<ViewControllerDelegate>delegate;

@end
