//
//  ItemVC.m
//  Grocery Dude
//
//  Created by Long Vinh Nguyen on 12/16/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "ItemVC.h"
#import "AppDelegate.h"
#import "Item.h"
#import "LocationAtHome.h"
#import "LocationAtShop.h"
#import "Unit.h"

@interface ItemVC ()

@end

@implementation ItemVC
#define debug 1

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - VIEW
- (void)refreshInterface
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (self.selectedItemID) {
        CoreDataHelper *cdh = [(AppDelegate *)[UIApplication sharedApplication].delegate cdh];
        Item *item = (Item *)[cdh.context existingObjectWithID:self.selectedItemID error:nil];
        self.nameTextField.text = item.name;
        self.quantityTextField.text = item.quantity.stringValue;
        self.unitPickerTextField.text = item.unit.name;
        self.unitPickerTextField.selectedObjectID = item.unit.objectID;
        self.homeLocationPickerTextField.text = item.locationAtHome.storedIn;
        self.homeLocationPickerTextField.selectedObjectID = item.locationAtHome.objectID;
        self.shopLocationPickerTextField.text = item.locationAtShop.aisle;
        self.shopLocationPickerTextField.selectedObjectID = item.locationAtShop.objectID;
    }
}

- (void)viewDidLoad
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    [super viewDidLoad];
    [self hideKeyboardWhenBackgroundIsTapped];
    self.unitPickerTextField.delegate = self;
    self.unitPickerTextField.pickerDelegate = self;
    self.homeLocationPickerTextField.delegate = self;
    self.homeLocationPickerTextField.pickerDelegate = self;
    self.shopLocationPickerTextField.delegate = self;
    self.shopLocationPickerTextField.pickerDelegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    [self refreshInterface];
    if ([self.nameTextField.text isEqual:@"New Item"]) {
        self.nameTextField.text = @"";
        [self.nameTextField becomeFirstResponder];
    }
    [self ensureItemHomeLocationIsNotNull];
    [self ensureItemShopLocationIsNotNull];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    CoreDataHelper *cdh = [(AppDelegate *)[UIApplication sharedApplication].delegate cdh];
    [cdh saveContext];
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
    [self.view addGestureRecognizer:tapGesture];
}

- (void)hideKeyboard
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [self.view endEditing:YES];
}


#pragma mark - DELEGATE
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    if (textField == self.nameTextField) {
        if ([self.nameTextField.text isEqualToString:@"New Item"]) {
            self.nameTextField.text = @"";
        }
    }
    if (textField == _unitPickerTextField) {
        [_unitPickerTextField fetch];
        [_unitPickerTextField.picker reloadAllComponents];
    } else if (textField == _homeLocationPickerTextField) {
        [_homeLocationPickerTextField fetch];
        [_homeLocationPickerTextField.picker reloadAllComponents];
    } else if (textField == _shopLocationPickerTextField) {
        [_shopLocationPickerTextField fetch];
        [_shopLocationPickerTextField.picker reloadAllComponents];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    CoreDataHelper *cdh = [(AppDelegate *)[UIApplication sharedApplication].delegate cdh];
    Item *item = (Item *)[cdh.context existingObjectWithID:self.selectedItemID error:nil];
    
    if (textField == self.nameTextField) {
        if ([self.nameTextField.text isEqualToString:@""]) {
            self.nameTextField.text = @"New Item";
        }
        item.name = self.nameTextField.text;
    } else if (textField == self.quantityTextField) {
        item.quantity = [NSNumber numberWithFloat:self.quantityTextField.text.floatValue];
    }
}

#pragma mark - DATA
- (void)ensureItemHomeLocationIsNotNull
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (self.selectedItemID) {
        CoreDataHelper *cdh = [(AppDelegate *)[UIApplication sharedApplication].delegate cdh];
        Item *item = (Item *)[cdh.context existingObjectWithID:self.selectedItemID error:nil];
        
        
        if (!item.locationAtHome) {
            NSFetchRequest *request = [[cdh model] fetchRequestTemplateForName:@"UnknowLocationAtHome"];
            NSArray *fetchedObjects = [cdh.context executeFetchRequest:request error:nil];
            if (fetchedObjects.count > 0) {
                item.locationAtHome = [fetchedObjects objectAtIndex:0];
            } else {
                LocationAtHome *locationAtHome = [NSEntityDescription insertNewObjectForEntityForName:@"LocationAtHome" inManagedObjectContext:cdh.context];
                NSError *error = nil;
                if (![cdh.context obtainPermanentIDsForObjects:@[locationAtHome] error:nil]) {
                    NSLog(@"Couldn't obtain a permanent ID for object %@", error);
                }
                
                locationAtHome.storedIn = @"..Unknown Location..";
                item.locationAtHome = locationAtHome;
            }
        }
    }
}

- (void)ensureItemShopLocationIsNotNull
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (self.selectedItemID) {
        CoreDataHelper *cdh = [(AppDelegate *)[UIApplication sharedApplication].delegate cdh];
        Item *item = (Item *)[cdh.context existingObjectWithID:self.selectedItemID error:nil];
        
        
        if (!item.locationAtShop) {
            NSFetchRequest *request = [[cdh model] fetchRequestTemplateForName:@"UnknowLocationAtShop"];
            NSArray *fetchedObjects = [cdh.context executeFetchRequest:request error:nil];
            if (fetchedObjects.count > 0) {
                item.locationAtShop = [fetchedObjects objectAtIndex:0];
            } else {
                LocationAtShop *locationAtShop = [NSEntityDescription insertNewObjectForEntityForName:@"LocationAtShop" inManagedObjectContext:cdh.context];
                NSError *error = nil;
                if (![cdh.context obtainPermanentIDsForObjects:@[locationAtShop] error:nil]) {
                    NSLog(@"Couldn't obtain a permanent ID for object %@", error);
                }
                
                locationAtShop.aisle = @"..Unknown Location..";
                item.locationAtShop = locationAtShop;
            }
        }
    }
}

#pragma mark - PICKERS
- (void)selectedObjectID:(NSManagedObjectID *)objectID changedForPickerTF:(CoreDataPickerTF *)pickerTF
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (self.selectedItemID) {
        CoreDataHelper *cdh = [(AppDelegate *)[UIApplication sharedApplication].delegate cdh];
        Item *item = (Item *)[cdh.context existingObjectWithID:self.selectedItemID error:nil];
        NSError *error = nil;
        if (pickerTF == self.unitPickerTextField) {
            Unit *unit = (Unit *)[cdh.context existingObjectWithID:objectID error:&error];
            item.unit = unit;
            self.unitPickerTextField.text = item.unit.name;
        } else if (pickerTF == self.homeLocationPickerTextField) {
            LocationAtHome *locationAtHome = (LocationAtHome *)[cdh.context existingObjectWithID:objectID error:&error];
            item.locationAtHome = locationAtHome;
            self.homeLocationPickerTextField.text = locationAtHome.storedIn;
        } else if (pickerTF == self.shopLocationPickerTextField)
        {
            LocationAtShop *locationAtShop = (LocationAtShop *)[cdh.context existingObjectWithID:objectID error:&error];
            item.locationAtShop = locationAtShop;
            self.shopLocationPickerTextField.text = locationAtShop.aisle;
        }
        [self refreshInterface];
        if (error) {
            NSLog(@"Error selecting object on picker: %@, %@", error, error.localizedDescription);
        }
    }
}

- (void)selectedObjectClearedForPickerTF:(CoreDataPickerTF *)pickerTF
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (self.selectedItemID) {
        CoreDataHelper *cdh = [(AppDelegate *)[UIApplication sharedApplication].delegate cdh];
        Item *item = (Item *)[cdh.context existingObjectWithID:self.selectedItemID error:nil];
        if (pickerTF == self.unitPickerTextField) {
            item.unit = nil;
            self.unitPickerTextField.text = @"";
        } else if (pickerTF == self.homeLocationPickerTextField) {
            item.locationAtHome = nil;
            self.homeLocationPickerTextField.text = @"";
        } else if (pickerTF == self.shopLocationPickerTextField)
        {
            item.locationAtShop = nil;
            self.shopLocationPickerTextField.text = @"";
        }
        [self refreshInterface];
    }
}

@end
