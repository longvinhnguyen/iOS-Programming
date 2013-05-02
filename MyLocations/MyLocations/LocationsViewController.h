//
//  LocationsViewController.h
//  MyLocations
//
//  Created by Long Vinh Nguyen on 5/1/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationsViewController : UITableViewController<NSFetchedResultsControllerDelegate>

@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;

@end
