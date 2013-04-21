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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if (self.checkListToEdit != nil) {
        self.title = @"Edit Checklist";
        self.textField.text = _checkListToEdit.name;
        self.doneBarButton.enabled = YES;
    }
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


#pragma mark - ListDetailViewController actions
- (IBAction)cancel:(id)sender
{
    [self.delegate listDetailViewControllerDidCancel:self];
}

- (IBAction)done:(id)sender
{
    if (self.checkListToEdit != nil) {
        self.checkListToEdit.name = self.textField.text;
        [self.delegate listDetailViewController:self didFinishEditingCheckList:self.checkListToEdit];
    } else {
        CheckList *checkList = [[CheckList alloc] init];
        checkList.name = self.textField.text;
        [self.delegate listDetailViewController:self didFinishAddingCheckList:checkList];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    self.doneBarButton.enabled = (newText.length > 0);
    return YES;
}


















@end
