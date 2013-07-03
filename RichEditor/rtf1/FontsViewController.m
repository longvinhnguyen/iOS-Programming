//
//  FontsViewController.m
//  rtf1
//
//  Created by Marin Todorov on 07/08/2012.
//  Copyright (c) 2012 Marin Todorov. All rights reserved.
//

#import "FontsViewController.h"

@interface FontsViewController () <UIPickerViewDataSource>
{
    IBOutlet UIPickerView* fontPicker;
    IBOutlet UIButton* btnApply;
}

@end

@implementation FontsViewController

-(void)awakeFromNib
{
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Font picker";
}

-(void)viewDidAppear:(BOOL)animated
{
}

-(void)viewDidDisappear:(BOOL)animated
{
}


#pragma mark UIPickerViewDataSource methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 0;
}

#pragma mark button actions
-(IBAction)btnDoneTapped:(id)sender
{
}

@end
