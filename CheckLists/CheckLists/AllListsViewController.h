//
//  AllListsViewController.h
//  CheckLists
//
//  Created by Long Vinh Nguyen on 4/21/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListDetailViewController.h"
@class DataModel;

@interface AllListsViewController : UITableViewController<ListDetailViewControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) DataModel *dataModel;

@end
