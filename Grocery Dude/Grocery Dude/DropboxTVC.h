//
//  DropboxTVC.h
//  Grocery Dude
//
//  Created by Long Vinh Nguyen on 12/26/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "CoreDataHelper.h"
#import "DropboxHelper.h"

@interface DropboxTVC : UITableViewController<UIAlertViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) NSMutableArray *contents;
@property (nonatomic, assign) BOOL loading;

@property (nonatomic, strong) UIActionSheet *options;
@property (nonatomic, strong) UIAlertView *confirmRestore;
@property (nonatomic, strong) NSString *selectedZipFileName;


@end
