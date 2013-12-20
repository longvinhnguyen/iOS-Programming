//
//  ItemVC.h
//  Grocery Dude
//
//  Created by Long Vinh Nguyen on 12/16/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UnitPickerTF.h"
#import "LocationAtShopTF.h"
#import "LocationAtHomeTF.h"
@import CoreData;

@interface ItemVC : UIViewController<UITextFieldDelegate, CoreDataPickerTFDelegate>

@property (nonatomic, strong) NSManagedObjectID *selectedItemID;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UITextField *nameTextField;
@property (nonatomic, weak) IBOutlet UITextField *quantityTextField;
@property (nonatomic, weak) IBOutlet UnitPickerTF *unitPickerTextField;
@property (nonatomic, weak) IBOutlet LocationAtHomeTF *homeLocationPickerTextField;
@property (nonatomic, weak) IBOutlet LocationAtShopTF *shopLocationPickerTextField;
@property (nonatomic, weak) IBOutlet UITextField *activeField;

@end
