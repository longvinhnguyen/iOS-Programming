//
//  LocationDetailsViewController.h
//  MyLocations
//
//  Created by Long Vinh Nguyen on 4/29/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryPickerViewController.h"
@class LocationDetailsViewController;
@class Location;


@interface LocationDetailsViewController : UITableViewController<UITextViewDelegate,CategoryPickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (nonatomic,weak) IBOutlet UITextView *textViewDescription;
@property (nonatomic,weak) IBOutlet UILabel *categoryLabel;
@property (nonatomic,weak) IBOutlet UILabel *latitudeLabel;
@property (nonatomic,weak) IBOutlet UILabel *longtitudeLabel;
@property (nonatomic,weak) IBOutlet UILabel *addressLabel;
@property (nonatomic,weak) IBOutlet UILabel *dateLabel;

@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
@property (nonatomic,strong) CLPlacemark *placemark;
@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic,strong) IBOutlet UIImageView *imageView;
@property (nonatomic,strong) IBOutlet UILabel *photoLabel;

@property (nonatomic,strong) Location *locationToEdit;


- (IBAction)cancel;
- (IBAction)tag:(id)sender;

@end


