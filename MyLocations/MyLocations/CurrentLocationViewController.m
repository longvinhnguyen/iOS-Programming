//
//  FirstViewController.m
//  MyLocations
//
//  Created by Long Vinh Nguyen on 4/28/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "CurrentLocationViewController.h"
#import "LocationDetailsViewController.h"

@implementation CurrentLocationViewController
{
    CLLocationManager *locationManager;
    CLLocation *location;
    NSError *lastLocationError;
    BOOL updatingLocation;

    CLGeocoder *geocoder;
    CLPlacemark *_placemark;
    BOOL performReverseGeocoding;
    NSError *lastGeocodingError;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        locationManager = [[CLLocationManager alloc] init];
        geocoder = [[CLGeocoder alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self updateLabels];
    [self configureGetButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (IBAction)getLocation:(id)sender
{
    if (updatingLocation) {
        [self stopLocationManager];
    } else {
        location = nil;
        lastLocationError = nil;
        _placemark = nil;
        lastLocationError = nil;
        [self startLocationManager];
    }

    [self updateLabels];
    [self configureGetButton];
}

- (NSString *)stringFromPlaceMark:(CLPlacemark *)placemark
{
    return [NSString stringWithFormat:@"%@ %@\n%@ %@ %@", placemark.subThoroughfare, placemark.thoroughfare, placemark.locality, placemark.administrativeArea, placemark.postalCode];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"TagLocation"]) {
        UINavigationController *nav = (UINavigationController *) segue.destinationViewController;
        LocationDetailsViewController *lvc = (LocationDetailsViewController *)nav.topViewController;
        lvc.managedObjectContext = _managedObjectContext;
        lvc.coordinate = location.coordinate;
        lvc.placemark = _placemark;
    }
}

#pragma mark - methods
- (void)updateLabels
{
    if (location != nil) {
        self.messageLabel.text = @"GPS Coordinates";
        self.latitudeLabel.text = [NSString stringWithFormat:@"%.8f",location.coordinate.latitude];
        self.longtitudeLabel.text = [NSString stringWithFormat:@"%.8f",location.coordinate.longitude];
        self.tagButton.hidden = NO;
        
        if (_placemark != nil) {
            self.addressLabel.text = [self stringFromPlaceMark:_placemark];
        } else if (performReverseGeocoding) {
            self.addressLabel.text = @"Searching for address...";
        } else if (lastLocationError != nil) {
            self.addressLabel.text = @"Error finding address";
        } else {
            self.addressLabel.text = @"No address found";
        }
        
        
    } else {
        self.latitudeLabel.text = @"";
        self.longtitudeLabel.text = @"";
        self.addressLabel.text = @"";
        self.tagButton.hidden = YES;
        
        NSString *statusMessage;
        if (lastLocationError != nil) {
            if ([lastLocationError.domain isEqualToString:kCLErrorDomain] && lastLocationError.code == kCLErrorDenied) {
                statusMessage = @"Location Services Disabled";
            } else {
                statusMessage = @"Error Getting Location";
            }
        } else if (![CLLocationManager locationServicesEnabled]) {
            statusMessage = @"Location Services Disabled";
        } else if (updatingLocation) {
            statusMessage = @"Searching ...";
        } else {
            statusMessage = @"Press the Button to start";
        }
        
        self.messageLabel.text = statusMessage;
    }
}

- (void)stopLocationManager
{
    if (updatingLocation) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(didTimeOut:) object:nil];
        [locationManager stopUpdatingLocation];
        locationManager.delegate = nil;
        [self updateLabels];
        updatingLocation = NO;
    }
}

- (void)startLocationManager
{
    if ([CLLocationManager locationServicesEnabled]) {
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        [locationManager startUpdatingLocation];
        updatingLocation = YES;
        
        [self performSelector:@selector(didTimeOut:) withObject:nil afterDelay:60];
    }
}

- (void)configureGetButton
{
    if (updatingLocation) {
        [self.getButton setTitle:@"Stop" forState:UIControlStateNormal];
    } else {
        [self.getButton setTitle:@"Get My Location" forState:UIControlStateNormal];
    }
}

- (void)didTimeOut:(id)obj
{
    VLog(@"*** Time out");
    if (location == nil) {
        [self stopLocationManager];
        lastLocationError = [NSError errorWithDomain:@"MyLocationErrorDomain" code:1 userInfo:nil];
        [self updateLabels];
        [self configureGetButton];
    }
}

#pragma mark - CLLocationManager delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = [locations lastObject];
    if ([newLocation.timestamp timeIntervalSinceNow] < -5.0) {
        return;
    }
    
    if (newLocation.horizontalAccuracy < 0) {
        return;
    }
    
    // This is new
    CLLocationDistance distance = MAXFLOAT;
    if (location != nil) {
        distance = [newLocation distanceFromLocation:location];
    }
    
    if (location == nil || location.horizontalAccuracy > newLocation.horizontalAccuracy) {
        VLog(@"New Location: %@", newLocation);
        lastLocationError = nil;
        location = newLocation;
        //[self updateLabels];
        
        if (newLocation.horizontalAccuracy <= locationManager.desiredAccuracy) {
            VLog(@"*** We are done");
            [self stopLocationManager];
            [self configureGetButton];
            if (distance > 0) {
                performReverseGeocoding = NO;
            }
            
        }

        if (!performReverseGeocoding) {
            VLog(@"*** Going to geocode");
            performReverseGeocoding = YES;
            
            [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error){
                lastLocationError = error;
                if (error == nil && [placemarks count] > 0) {
                    _placemark = [placemarks lastObject];
                } else {
                    _placemark = nil;
                }
                performReverseGeocoding = NO;
                VLog(@"Found placemarks: %@ %@",_placemark, [error localizedDescription]);
                [self updateLabels];
            }];
        }
    } else if (distance < 1.0) {
        NSTimeInterval timeInterval = [newLocation.timestamp timeIntervalSinceDate:location.timestamp];
        if (timeInterval > 10) {
            VLog(@"Force done");
            [self stopLocationManager];
            [self updateLabels];
            [self configureGetButton];
        }
    }
    
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    VLog(@"didFailWithError %@", [error localizedDescription]);
    if (error.code == kCLErrorLocationUnknown) {
        return;
    }
    [manager stopUpdatingLocation];
    lastLocationError = error;
    [self updateLabels];
}




@end
