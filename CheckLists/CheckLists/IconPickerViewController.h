//
//  IconPickerViewController.h
//  CheckLists
//
//  Created by Long Vinh Nguyen on 4/24/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IconPickerViewController;

@protocol IconPickerViewControllerDelegate <NSObject>

- (void)iconPicker:(IconPickerViewController *)picker didPickIcon:(NSString *) iconName;

@end

@interface IconPickerViewController : UITableViewController

@property (nonatomic, weak) id<IconPickerViewControllerDelegate> delegate;

@end
