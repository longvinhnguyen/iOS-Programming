//
//  CoreDataTVC.h
//  Grocery Dude
//
//  Created by Long Vinh Nguyen on 12/12/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataHelper.h"

@interface CoreDataTVC : UITableViewController<NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *frc;

- (void)performFetch;

@end
