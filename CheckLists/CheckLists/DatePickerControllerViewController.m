//
//  DatePickerControllerViewController.m
//  CheckLists
//
//  Created by Long Vinh Nguyen on 4/25/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "DatePickerControllerViewController.h"

@implementation DatePickerControllerViewController
{
    UILabel *dateLabel;
}

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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.datePicker setDate:_date animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark DatePickerViewController actions
- (IBAction)cancel
{
    [self.delegate datePickerdidCancel:self];
}

- (IBAction)done:(id)sender
{
    [self dateChanged];
    [self.delegate datePicker:self didPickDate:self.date];
}

- (void)dateChanged
{
    self.date = self.datePicker.date;
}

- (void)updateDateLabel
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeStyle:NSDateFormatterMediumStyle];
    [df setDateStyle:NSDateFormatterMediumStyle];
    dateLabel.text = [df stringFromDate:self.date];
}


#pragma mark - UITableViewDelegate & DateSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DateCell"];
    dateLabel = (UILabel *)[cell viewWithTag:1000];
    [self updateDateLabel];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 77;
}













@end
