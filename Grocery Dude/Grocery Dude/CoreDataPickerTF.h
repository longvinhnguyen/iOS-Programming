//
//  CoreDataPickerTF.h
//  Grocery Dude
//
//  Created by Long Vinh Nguyen on 12/19/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataHelper.h"
@class CoreDataPickerTF;

@protocol CoreDataPickerTFDelegate <NSObject>

- (void)selectedObjectID:(NSManagedObjectID *)objectID changedForPickerTF:(CoreDataPickerTF *)pickerTF;
- (void)selectedObjectClearedForPickerTF:(CoreDataPickerTF *)pickerTF;

@end

@interface CoreDataPickerTF : UITextField<UIKeyInput, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, weak) id<CoreDataPickerTFDelegate> pickerDelegate;
@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, strong) NSArray *pickerData;
@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, assign) BOOL showToolBar;
@property (nonatomic, strong) NSManagedObjectID *selectedObjectID;

- (void)fetch;
- (void)selectDefaultRow;

@end
