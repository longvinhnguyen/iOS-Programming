//
//  ItemVC.h
//  Grocery Dude
//
//  Created by Long Vinh Nguyen on 12/16/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreData;

@interface ItemVC : UIViewController<UITextFieldDelegate>

@property (nonatomic, strong) NSManagedObjectID *selectedItemID;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UITextField *nameTextField;
@property (nonatomic, weak) IBOutlet UITextField *quantityTextField;

@end
