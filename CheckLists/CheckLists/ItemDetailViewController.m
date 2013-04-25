//
//  AddItemViewController.m
//  CheckLists
//
//  Created by Long Vinh Nguyen on 4/19/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "ItemDetailViewController.h"
#import "CheckListItem.h"

@implementation ItemDetailViewController
{
    NSDate *dueDate;
}
@synthesize textField = _textField, delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    if (_itemToEdit != nil) {
        self.title = @"Edit Item";
        self.textField.text = _itemToEdit.text;
        self.doneBarButton.enabled = YES;
        self.switchControl.on = _itemToEdit.shouldRemind;
        dueDate = _itemToEdit.dueDate;
    } else {
        self.switchControl = NO;
        dueDate = [NSDate date];
    }
    [self updateDueDateLabel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.textField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateDueDateLabel
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterMediumStyle];
    [df setTimeStyle:NSDateFormatterShortStyle];
    self.dueDateLabel.text = [df stringFromDate:dueDate];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)cancel:(id)sender
{
    [self.delegate itemViewContronllerDidCancel:self];
}

- (void)done:(id)sender
{
    if (self.itemToEdit != nil) {
        self.itemToEdit.text = _textField.text;
        self.itemToEdit.shouldRemind = _switchControl.on;
        self.itemToEdit.dueDate = dueDate;
        
        [self.delegate itemViewController:self didFinishEditingItem:self.itemToEdit];
    } else {
        CheckListItem *item = [[CheckListItem alloc] init];
        item.text = self.textField.text;
        item.checked = NO;
        item.dueDate = dueDate;
        item.shouldRemind = _switchControl.on;
        
        [self.delegate itemViewController:self didFinishAddingItem:item];
    }

}

#pragma mark - UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    self.doneBarButton.enabled = [newText length] > 0;
    
    return YES;
}


@end
