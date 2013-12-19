//
//  CoreDataPickerTF.m
//  Grocery Dude
//
//  Created by Long Vinh Nguyen on 12/19/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "CoreDataPickerTF.h"

@implementation CoreDataPickerTF
#define debug 1


#pragma mark - DELEGATE & DATASOURCE: UIPickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return self.pickerData.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return 44.0f;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return 280.0f;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return [self.pickerData objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    NSManagedObject *object = [self.pickerData objectAtIndex:row];
    [self.pickerDelegate selectedObjectID:[object objectID] changedForPickerTF:self];
}

#pragma mark - INTERACTION
- (void)done
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [self resignFirstResponder];
}

- (void)clear
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [self.pickerDelegate selectedObjectClearedForPickerTF:self];
    [self resignFirstResponder];
}

#pragma mark - DATA
- (void)fetch
{
    [NSException raise:NSInternalInconsistencyException format:@"You must override '%@' method to provide data to picker", NSStringFromSelector(_cmd)];
}

- (void)selectDefaultRow
{
    [NSException raise:NSInternalInconsistencyException format:@"You must override '%@' method to set the default picker row", NSStringFromSelector(_cmd)];
}

#pragma mark - VIEW
- (UIView *)createInputView
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    self.picker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    self.picker.showsSelectionIndicator = YES;
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.picker.dataSource = self;
    self.picker.delegate = self;
    [self fetch];
    return self.picker;
}


- (UIView *)createInputAccessoryView
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    self.showToolBar = YES;
    if (!self.toolBar && self.showToolBar) {
        self.toolBar = [[UIToolbar alloc] init];
        self.toolBar.barStyle = UIBarStyleBlackTranslucent;
        self.toolBar.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.toolBar sizeToFit];
        CGRect frame = self.toolBar.frame;
        frame.size.height = 44.0f;
        self.toolBar.frame = frame;
        
        UIBarButtonItem *clearBtn = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStyleBordered target:self action:@selector(clear)];
        UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
        NSArray *array = [NSArray arrayWithObjects:clearBtn, spacer, doneBtn, nil];
        self.toolBar.items = array;
    }
    
    return self.toolBar;
}

- (id)initWithFrame:(CGRect)frame
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    if (self = [super initWithFrame:frame]) {
        self.inputView = [self createInputView];
        self.inputAccessoryView = [self createInputAccessoryView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    if (self = [super initWithCoder:aDecoder]) {
        self.inputView = [self createInputView];
        self.inputAccessoryView = [self createInputAccessoryView];
    }
    
    return self;
}

- (void)deviceDidRotate:(NSNotification *)notification
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [self.picker setNeedsLayout];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
