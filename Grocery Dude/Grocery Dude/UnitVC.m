//
//  UnitVC.m
//  Grocery Dude
//
//  Created by Long Vinh Nguyen on 12/17/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "UnitVC.h"
#import "Unit.h"
#import "AppDelegate.h"

@interface UnitVC ()

@end

@implementation UnitVC
#define debug 0



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - VIEW
- (void)refreshInterface
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (self.selectedObjectID) {
        CoreDataHelper *cdh = [(AppDelegate *)[UIApplication sharedApplication].delegate cdh];
        Unit *unit = (Unit *)[cdh.context existingObjectWithID:self.selectedObjectID error:nil];
        unit.modified = [NSDate date];
        self.nameTextField.text = unit.name;
    }
}


- (void)viewDidLoad
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    [super viewDidLoad];
    [self hideKeyboardWhenBackgroundIsTapped];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    [self refreshInterface];
    [self.nameTextField becomeFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    CoreDataHelper *cdh = [(AppDelegate *)[UIApplication sharedApplication].delegate cdh];
    [cdh backgroundSaveContext];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SomethingChanged" object:nil userInfo:nil];
}

#pragma mark - TEXTFIELD
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CoreDataHelper *cdh = [(AppDelegate *)[UIApplication sharedApplication].delegate cdh];
    Unit *unit = (Unit *)[cdh.context existingObjectWithID:self.selectedObjectID error:nil];
    if (textField == self.nameTextField) {
        unit.name = self.nameTextField.text;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SomethingChanged" object:nil];
}

#pragma mark - INTERACTION
- (IBAction)done:(id)sender
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [self hideKeyboard];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)hideKeyboardWhenBackgroundIsTapped
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [tapGesture setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)hideKeyboard
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
