//
//  ListDetailViewController.h
//  CheckLists
//
//  Created by Long Vinh Nguyen on 4/21/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ListDetailViewController;
@class CheckList;

@protocol ListDetailViewControllerDelegate <NSObject>

- (void)listDetailViewControllerDidCancel:(ListDetailViewController *)controller;
- (void)listDetailViewController:(ListDetailViewController *)controller didFinishAddingCheckList:(CheckList *)checkList;
- (void)listDetailViewController:(ListDetailViewController *)controller didFinishEditingCheckList:(CheckList *)checkList;

@end

@interface ListDetailViewController : UITableViewController<UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UITextField *textField;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *doneBarButton;
@property (nonatomic, weak) id<ListDetailViewControllerDelegate> delegate;
@property (nonatomic, strong) CheckList *checkListToEdit;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end
