//
//  WhereamiViewController.h
//  Whereami
//
//  Created by Long Vinh Nguyen on 1/23/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface WhereamiViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate, UITextFieldDelegate>
{
    CLLocationManager *locationManager;
    
    __weak IBOutlet MKMapView *worldView;
    __weak IBOutlet UIActivityIndicatorView *activityIndicator;
    __weak IBOutlet UITextField *locationTitleField;
    __weak IBOutlet UISegmentedControl *segmentControl;
}

- (void)findLocation;
- (void)foundLocation:(CLLocation *)loc;
- (IBAction)changeMapType;



@end
