//
//  CheckListsViewController.h
//  CheckLists
//
//  Created by Long Vinh Nguyen on 4/19/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemDetailViewController.h"
@class CheckList;

@interface CheckListViewController : UITableViewController<ItemDetailViewControllerDelegate>

@property (nonatomic, strong) CheckList *checkList;

@end
