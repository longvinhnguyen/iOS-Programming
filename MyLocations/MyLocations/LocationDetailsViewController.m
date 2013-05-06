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
#import "NSMutableString+AddText.h"

@implementation LocationDetailsViewController
{
    NSString *descriptionText;
    NSString *categoryName;
    NSDate *date;
    UIImage *image;
    UIImagePickerController *imagePicker;
    UIActionSheet *actionSheet;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        descriptionText = @"";
        categoryName = @"No Category";
        date = [NSDate date];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.locationToEdit != nil) {
        self.title = @"Edit Location";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(tag:)];
        
        if ([self.locationToEdit hasPhoto] && image == nil) {
            UIImage *existingImage = [self.locationToEdit photoImage];
            [self showImage:existingImage];
        }
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
    
    if (image != nil) {
        [self showImage:image];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
}

- (NSString *)stringFromPlacemark
{
    NSMutableString *line = [[NSMutableString alloc] initWithCapacity:100];
    [line addText:_placemark.subThoroughfare withSeparator:@""];
    [line addText:_placemark.thoroughfare withSeparator:@" "];
    
    [line addText:_placemark.locality withSeparator:@", "];
    [line addText:_placemark.administrativeArea withSeparator:@", "];
    [line addText:_placemark.postalCode withSeparator:@", "];
    [line addText:_placemark.country withSeparator:@", "];
    
    return line;
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

- (void)takePhoto
{
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    [[self navigationController] presentViewController:imagePicker animated:YES completion:nil];
}

- (void)choosePhotoFromLibrary
{
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    [[self navigationController] presentViewController:imagePicker animated:YES completion:nil];
}

- (void)showPhotoMenu
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] || true) {
       actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose From Library",nil];
        [actionSheet showInView:self.view];
    } else {
        [self choosePhotoFromLibrary];
    }
}

- (void)showImage:(UIImage *)theImage
{
    self.imageView.image = theImage;
    self.imageView.hidden = NO;
    float ratio = self.imageView.image.size.width / self.imageView.image.size.height;
    self.imageView.frame = CGRectMake(10, 10, 260, 260/ratio);
    self.photoLabel.hidden = YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (int)nextPhotoId
{
    int photoId = [[NSUserDefaults standardUserDefaults] integerForKey:@"PhotoID"];
    [[NSUserDefaults standardUserDefaults] setInteger:photoId + 1 forKey:@"PhotoID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return photoId;
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
        location.photoId = -1;
        hudView.text = @"Tagged";
    }

    location.locationDescription = descriptionText;
    location.category = categoryName;
    location.latitude = _coordinate.latitude;
    location.longtitude = _coordinate.longitude;
    location.date = date;
    location.placemark = _placemark;
    
    if (image != nil) {
        if (![location hasPhoto]) {
            location.photoId = [self nextPhotoId];
        }
    }
    
    NSData *data = UIImagePNGRepresentation(image);
    NSError *error;
    if (![data writeToFile:[location photoPath] options:NSDataWritingAtomic error:&error]) {
        VLog(@"%@",[error localizedDescription]);
    }
    
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
    } else if (indexPath.section == 1) {
        if (self.imageView.hidden) {
            return 44;
        } else {
            return self.imageView.bounds.size.height + 20;
        }
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

#pragma mark - UITableView delegate

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
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self showPhotoMenu];
    }
}

#pragma mark - CategoryViewController delegate
- (void)categoryPicker:(CategoryPickerViewController *)picker didPickCategory:(NSString *)theCategoryName
{
    categoryName = theCategoryName;
    self.categoryLabel.text = categoryName;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIImagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    image = [info objectForKey:UIImagePickerControllerEditedImage];
    if ([self isViewLoaded]) {
        [self showImage:image];
        [self.tableView reloadData];
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    imagePicker = nil;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    imagePicker = nil;
}

#pragma mark - UIActionSheet delegate
- (void)actionSheet:(UIActionSheet *)theActionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self takePhoto];
    } else if (buttonIndex == 1) {
        [self choosePhotoFromLibrary];
    }
    actionSheet = nil;
}

#pragma mark NSNotificationCenter methods
- (void)applicationDidEnterBackground
{
    if (imagePicker) {
        [self.navigationController dismissViewControllerAnimated:NO completion:nil];
        imagePicker = nil;
    }
    
    if (actionSheet) {
        [actionSheet dismissWithClickedButtonIndex:actionSheet.cancelButtonIndex animated:NO];
        actionSheet = nil;
    }
    
    [self.textViewDescription resignFirstResponder];
}

@end











