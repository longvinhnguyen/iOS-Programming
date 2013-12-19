//
//  UnitVC.h
//  Grocery Dude
//
//  Created by Long Vinh Nguyen on 12/17/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreData;

@interface UnitVC : UIViewController<UITextFieldDelegate>

@property (nonatomic, strong) NSManagedObjectID *selectedObjectID;
@property (nonatomic, weak) IBOutlet UITextField *nameTextField;

@end
