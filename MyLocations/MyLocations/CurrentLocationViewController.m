//
//  FirstViewController.m
//  MyLocations
//
//  Created by Long Vinh Nguyen on 4/28/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "CurrentLocationViewController.h"
#import "LocationDetailsViewController.h"
#import "NSMutableString+AddText.h"


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
    UIActivityIndicatorView *spinner;
    
    SystemSoundID soundId;
    
    UIImageView *logoImageView;
    BOOL firstTime;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        locationManager = [[CLLocationManager alloc] init];
        geocoder = [[CLGeocoder alloc] init];
        firstTime = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self updateLabels];
    [self configureGetButton];
    [self loadSoundEffect];
    
    if (firstTime) {
        [self showLogoView];
    } else {
        [self hideLogoViewAnimated:NO];
    }
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
    if (firstTime) {
        firstTime = NO;
        [self hideLogoViewAnimated:YES];
    }
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
    NSMutableString *line1 = [[NSMutableString alloc] initWithCapacity:100];
    [line1 addText:placemark.subThoroughfare withSeparator:@""];
    [line1 addText:placemark.thoroughfare withSeparator:@" "];
    
    NSMutableString *line2 = [[NSMutableString alloc] init];
    [line2 addText:placemark.locality withSeparator:@""];
    [line2 addText:placemark.administrativeArea withSeparator:@" "];
    [line2 addText:placemark.postalCode withSeparator:@" "];
    [line1 addText:line2 withSeparator:@"\n"];
    
    return line1;
}

- (void)addText:(NSString *)text toLine:(NSMutableString *)line withSeparator:(NSString *)separator
{
    if (line != nil) {
        if (line.length > 0) {
            [line appendString:separator];
        }
        if (text != nil && text.length > 0) {
            [line appendString:text];
        }
    }
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
        _latitudeTextLabel.hidden = NO;
        _longTitudeTextLabel.hidden = NO;
        
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
        _latitudeTextLabel.hidden = YES;
        _longTitudeTextLabel.hidden = YES;
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
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        spinner.center = CGPointMake(self.getButton.bounds.size.width - spinner.bounds.size.width/2.0f - 10, self.getButton.bounds.size.height / 2.0f);
        [spinner startAnimating];
        [self.getButton addSubview:spinner];
    } else {
        [self.getButton setTitle:@"Get My Location" forState:UIControlStateNormal];
        [spinner removeFromSuperview];
        spinner = nil;
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
                    VLog(@"First Time");
                    [self playSoundEffect];
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

#pragma mark - Sound Effect
- (void)loadSoundEffect
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Sound.caf" ofType:nil];
    NSURL *fileURL = [NSURL fileURLWithPath:path];
    
    if (fileURL == nil) {
        VLog(@"NSURL is nil for path: %@", path);
        return;
    }
    
    OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileURL, &soundId);
    if (error != kAudioServicesNoError) {
        VLog(@"Error code %ld loading sound at path", error);
        return;
    }
}

- (void)unloadSoundEffect
{
    AudioServicesDisposeSystemSoundID(soundId);
    soundId = 0;
}


- (void)playSoundEffect
{
    AudioServicesPlaySystemSound(soundId);
}

#pragma mark - Logo View
- (void)showLogoView
{
    self.panelView.hidden = YES;
    logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Logo"]];
    logoImageView.center = CGPointMake(160.0f, 140.0f);
    [self.view addSubview:logoImageView];
}

- (void)hideLogoViewAnimated:(BOOL)animated
{
    self.panelView.hidden = NO;
    if (animated) {
        self.panelView.center = CGPointMake(600.0f, 140.0f);
        CABasicAnimation *panelMover = [CABasicAnimation animationWithKeyPath:@"position"];
        panelMover.removedOnCompletion = NO;
        panelMover.fillMode = kCAFillModeForwards;
        panelMover.duration = 0.6f;
        panelMover.fromValue = [NSValue valueWithCGPoint:self.panelView.center];
        panelMover.toValue = [NSValue valueWithCGPoint:CGPointMake(160.0f, self.panelView.center.y)];
        panelMover.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        panelMover.delegate = self;
        [self.panelView.layer addAnimation:panelMover forKey:@"panelMover"];
        
        CABasicAnimation *logoMover = [CABasicAnimation animationWithKeyPath:@"position"];
        logoMover.removedOnCompletion = NO;
        logoMover.fillMode = kCAFillModeForwards;
        logoMover.duration = 0.5f;
        logoMover.fromValue = [NSValue valueWithCGPoint:logoImageView.center];
        logoMover.toValue = [NSValue valueWithCGPoint:CGPointMake(-160.0f, logoImageView.center.y)];
        logoMover.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        [logoImageView.layer addAnimation:logoMover forKey:@"logoMover"];
        
        CABasicAnimation *logoRotator = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        logoRotator.removedOnCompletion = NO;
        logoRotator.fillMode = kCAFillModeForwards;
        logoRotator.duration = 0.5f;
        logoRotator.fromValue = [NSNumber numberWithFloat:0.0f];
        logoRotator.toValue = [NSNumber numberWithFloat:-2*M_PI];
        logoRotator.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        [logoImageView.layer addAnimation:logoRotator forKey:@"logoRotator"];
        
    } else {
        [logoImageView removeFromSuperview];
        logoImageView = nil;
    }

}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self.panelView.layer removeAllAnimations];
    self.panelView.center = CGPointMake(160.0f, 140.0f);
    
    [logoImageView.layer removeAllAnimations];
    [logoImageView removeFromSuperview];
    logoImageView = nil;
}






@end
