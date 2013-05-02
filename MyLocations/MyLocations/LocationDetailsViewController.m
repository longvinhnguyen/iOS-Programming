//
//  LocationDetailsViewController.m
//  MyLocations
//
//  Created by Long Vinh Nguyen on 4/29/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "LocationDetailsViewController.h"
#import "CategoryPickerViewController.h"
#import "HudView.h"
#import "Location.h"

@implementation LocationDetailsViewController
{
    NSString *descriptionText;
    NSString *categoryName;
    NSDate *date;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        descriptionText = @"";
        categoryName = @"No Category";
        date = [NSDate date];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.locationToEdit != nil) {
        self.title = @"Edit Location";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(tag:)];
    }
    
    self.textViewDescription.text = descriptionText;
    self.categoryLabel.text = categoryName;
    
    self.latitudeLabel.text = [NSString stringWithFormat:@"%.8f",_coordinate.latitude];
    self.longtitudeLabel.text = [NSString stringWithFormat:@"%.8f",_coordinate.longitude];
    self.addressLabel.text = [self stringFromPlacemark];
    self.dateLabel.text = [self formatDate:[NSDate date]];

    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:gestureRecognizer];
}

- (NSString *)stringFromPlacemark
{
    return [NSString stringWithFormat:@"%@ %@\n%@ %@ %@", _placemark.subThoroughfare, _placemark.thoroughfare, _placemark.locality, _placemark.administrativeArea, _placemark.postalCode];
}

- (NSString *)formatDate:(NSDate *)sdate
{
    static NSDateFormatter *formatter = nil;
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
    }
    return [formatter stringFromDate:date];
}

- (void)closeScreen
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)hideKeyboard:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    if (indexPath != nil && indexPath.section == 0 && indexPath.row == 0) {
        return;
    }
    [self.textViewDescription resignFirstResponder];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PickerCategory"]) {
        CategoryPickerViewController *controller = (CategoryPickerViewController *)segue.destinationViewController;
        controller.delegate = self;
        controller.selectedCategoryName = categoryName;
    }
}


- (void)setLocationToEdit:(Location *)locationToEdit
{
    if (_locationToEdit != locationToEdit) {
        _locationToEdit = locationToEdit;
        descriptionText = _locationToEdit.locationDescription;
        categoryName = _locationToEdit.category;
        date = _locationToEdit.date;
        self.coordinate = CLLocationCoordinate2DMake(_locationToEdit.latitude, _locationToEdit.longtitude);
        self.placemark = _locationToEdit.placemark;
        
    }
}

#pragma mark - LocationDetailsView actions

- (IBAction)cancel
{
    [self closeScreen];
}

- (IBAction)tag:(id)sender
{
    HudView *hudView = [HudView hudInView:self.navigationController.topViewController.view animated:YES];
    Location *location = nil;
    if (_locationToEdit != nil) {
        location = _locationToEdit;
        hudView.text = @"Updated";
    } else {
        location = [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:self.managedObjectContext];
        hudView.text = @"Tagged";
    }

    location.locationDescription = descriptionText;
    location.category = categoryName;
    location.latitude = _coordinate.latitude;
    location.longtitude = _coordinate.longitude;
    location.date = date;
    location.placemark = _placemark;
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        FATAL_CORE_DATA_ERROR(error);
    }
    
    [self performSelector:@selector(closeScreen) withObject:nil afterDelay:0.6];
}


#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 88;
    } else if (indexPath.section == 2 && indexPath.row == 2) {
        CGRect rect = CGRectMake(100, 10, 190, 1000);
        self.addressLabel.frame = rect;
        [self.addressLabel sizeToFit];
        rect.size.height = self.addressLabel.frame.size.height;
        self.addressLabel.frame = rect;
        return self.addressLabel.frame.size.height + 20;
    }
    return 44;
}

#pragma mark - UITextView delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    descriptionText = [textView.text stringByReplacingCharactersInRange:range withString:text];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    descriptionText = textView.text;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 1) {
        return indexPath;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self.textViewDescription becomeFirstResponder];
    }
}

#pragma mark - CategoryViewController delegate
- (void)categoryPicker:(CategoryPickerViewController *)picker didPickCategory:(NSString *)theCategoryName
{
    categoryName = theCategoryName;
    self.categoryLabel.text = categoryName;
    [self.navigationController popViewControllerAnimated:YES];
}


@end











