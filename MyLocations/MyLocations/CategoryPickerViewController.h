//
//  CategoryPickerViewController.h
//  MyLocations
//
//  Created by Long Vinh Nguyen on 4/30/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CategoryPickerViewController;

@protocol CategoryPickerViewControllerDelegate <NSObject>

- (void)categoryPicker:(CategoryPickerViewController *)picker didPickCategory:(NSString *)categoryName;

@end

@interface CategoryPickerViewController : UITableViewController

@property (nonatomic,weak)id<CategoryPickerViewControllerDelegate> delegate;
@property (nonatomic,strong) NSString *selectedCategoryName;

@end
