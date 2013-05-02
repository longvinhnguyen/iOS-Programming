//
//  ListDetailViewController.m
//  CheckLists
//
//  Created by Long Vinh Nguyen on 4/21/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "ListDetailViewController.h"
#import "CheckList.h"

@implementation ListDetailViewController
{
    NSString *iconName;
    NSString *text;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        iconName = @"Folder";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if (self.checkListToEdit != nil) {
        self.title = @"Edit Checklist";
    }
    self.textField.text = text;
    self.iconImageView.image = [UIImage imageNamed:iconName];
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
    
    
    if ([self isViewLoaded] && self.view.window ==  nil) {
        self.view  = nil;
    }
    
    if (self.view == nil) {
        self.textField = nil;
        self.doneBarButton = nil;
        self.iconImageView = nil;
    }
}

- (void)updateDoneBarButton
{
    self.doneBarButton.enabled = (text.length > 0);
}

- (void)setCheckListToEdit:(CheckList *)checkListToEdit
{
    if (_checkListToEdit != checkListToEdit) {
        _checkListToEdit = checkListToEdit;
        text = _checkListToEdit.name;
        iconName = _checkListToEdit.iconName;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PickIcon"]) {
        IconPickerViewController *controller = segue.destinationViewController;
        controller.delegate = self;
    }
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        return indexPath;
    } else
        return nil;
}


#pragma mark - ListDetailViewController actions
- (IBAction)cancel:(id)sender
{
    [self.delegate listDetailViewControllerDidCancel:self];
}

- (IBAction)done:(id)sender
{
    if (self.checkListToEdit != nil) {
        self.checkListToEdit.name = self.textField.text;
        self.checkListToEdit.iconName = iconName;
        
        [self.delegate listDetailViewController:self didFinishEditingCheckList:self.checkListToEdit];
    } else {
        CheckList *checkList = [[CheckList alloc] init];
        checkList.name = self.textField.text;
        checkList.iconName = iconName;
        
        [self.delegate listDetailViewController:self didFinishAddingCheckList:checkList];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [self updateDoneBarButton];
    return YES;
}

- (void)iconPicker:(IconPickerViewController *)picker didPickIcon:(NSString *)theIconName;
{
    iconName = theIconName;
    self.iconImageView.image = [UIImage imageNamed:iconName];
    [[self navigationController] popViewControllerAnimated:YES];
    
}


















@end
