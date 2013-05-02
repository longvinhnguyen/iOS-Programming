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
    NSString *text;
    BOOL shouldRemind;
}
@synthesize textField = _textField, delegate;


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        text = @"";
        shouldRemind = NO;
        dueDate = [NSDate date];
    }
    return self;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PickDate"]) {
        DatePickerControllerViewController *controller = segue.destinationViewController;
        controller.delegate = self;
        controller.date = dueDate;
    }
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
    }
    
    self.textField.text = text;
    self.switchControl.on = shouldRemind;
    
    [self updateDoneBarButton];
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
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
    
    if (self.view == nil) {
        self.doneBarButton = nil;
        self.switchControl = nil;
        self.dueDateLabel = nil;
        self.textField = nil;
    }
}

- (void)setItemToEdit:(CheckListItem *)itemToEdit
{
    if (_itemToEdit != itemToEdit) {
        _itemToEdit = itemToEdit;
        text = _itemToEdit.text;
        shouldRemind = _itemToEdit.shouldRemind;
        dueDate = _itemToEdit.dueDate;
    }
}

- (void)updateDoneBarButton
{
    self.doneBarButton.enabled = (text.length > 0);
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
    if (indexPath.row == 2) {
        return indexPath;
    }
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
        [self.itemToEdit scheduleNotification];
        
        
        [self.delegate itemViewController:self didFinishEditingItem:self.itemToEdit];
    } else {
        CheckListItem *item = [[CheckListItem alloc] init];
        item.text = self.textField.text;
        item.dueDate = dueDate;
        item.shouldRemind = _switchControl.on;
        [item scheduleNotification];
        
        [self.delegate itemViewController:self didFinishAddingItem:item];
    }

}

- (IBAction)switchChanged:(UISwitch *)sender
{
    shouldRemind = sender.on;
}


#pragma mark - UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [self updateDoneBarButton];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    text = textField.text;
    [self updateDoneBarButton];
}


#pragma mark - DatePickerViewControllerDelegate methods
- (void)datePickerdidCancel:(DatePickerControllerViewController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)datePicker:(DatePickerControllerViewController *)picker didPickDate:(NSDate *)date
{
    dueDate = date;
    [self updateDueDateLabel];
    [self dismissViewControllerAnimated:YES completion:nil];
}










@end
