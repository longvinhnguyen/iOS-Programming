//
//  DatePickerControllerViewController.h
//  CheckLists
//
//  Created by Long Vinh Nguyen on 4/25/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DatePickerControllerViewController;

@protocol DatePickerViewControllerDelegate <NSObject>

- (void)datePickerdidCancel:(DatePickerControllerViewController *)picker;
- (void)datePicker:(DatePickerControllerViewController *)picker didPickDate:(NSDate *)date;

@end


@interface DatePickerControllerViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, weak) id<DatePickerViewControllerDelegate> delegate;
@property (nonatomic, strong) NSDate *date;

- (IBAction)cancel;
- (IBAction)done:(id)sender;
- (void)dateChanged;


@end
