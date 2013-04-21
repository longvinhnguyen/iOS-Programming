//
//  AddItemViewController.h
//  CheckLists
//
//  Created by Long Vinh Nguyen on 4/19/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CheckListItem;
@class ItemDetailViewController;


@protocol ItemDetailViewControllerDelegate <NSObject>

- (void)itemViewContronllerDidCancel:(ItemDetailViewController *)controller;

- (void)itemViewController:(ItemDetailViewController *)controller didFinishAddingItem: (CheckListItem *)item;

- (void)itemViewController:(ItemDetailViewController *)controller didFinishEditingItem:(CheckListItem *)item;

@end


@interface ItemDetailViewController : UITableViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBarButton;
@property (nonatomic, weak) id<ItemDetailViewControllerDelegate> delegate;
@property (nonatomic, strong) CheckListItem *itemToEdit;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;


@end

