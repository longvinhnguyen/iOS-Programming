//
//  WhereamiViewController.m
//  Whereami
//
//  Created by Long Vinh Nguyen on 1/23/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import "WhereamiViewController.h"
#import "BNRMapPoint.h"

NSString * const WhereamiMapTypePrefKey = @"WhereamiMapTypePrefKey";

@implementation WhereamiViewController

+ (void)initialize
{
    NSDictionary *defaults = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:1] forKey:WhereamiMapTypePrefKey];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Create location manager object
        locationManager = [[CLLocationManager alloc] init];
        
        [locationManager setDelegate:self];
        [locationManager setDistanceFilter:50];
        

        // Add we want it to be as accurate as possible
        // regardless of how much time/power it takes
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        
        // Tell our manager to start looking for its location immediately
        // [locationManager startUpdatingHeading];
    }
    
    return self;
}

- (void)viewDidLoad
{
    //[worldView setMapType:MKMapTypeSatellite];
    [worldView setShowsUserLocation:YES];
    
    NSInteger mapTypeValue = [[NSUserDefaults standardUserDefaults] integerForKey:WhereamiMapTypePrefKey];
    
    // Update the UI
    [segmentControl setSelectedSegmentIndex:mapTypeValue];
    
    // Update the map
    [self changeMapType];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"%@",[locations objectAtIndex:0]);
    
    CLLocation *newLocation = [locations objectAtIndex:[locations count]-1];
    
    // How many seconds ago was this new location created?
    NSTimeInterval t = [[newLocation timestamp] timeIntervalSinceNow];
    
    // CLLocationManager will return the last found location of the device first, you don't want that data in this case
    // If this location was made more than 3 minutes ago, ignore it
    if (t < -180) {
        // This is cached data, you don't want it, keep looking
        return;
    }
    [self foundLocation:newLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Could not find location: %@",error);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    NSLog(@"%@",newHeading);
}

- (void)dealloc
{
    [locationManager setDelegate:nil];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    CLLocationCoordinate2D loc = [userLocation coordinate];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 250, 250);
    
    [worldView setRegion:region animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // This method isn't implemented yet - but will be soon
    [self findLocation];
    
    [textField resignFirstResponder];
    return YES;
}

- (void)findLocation
{
    [locationManager startUpdatingLocation];
    [activityIndicator startAnimating];
    [locationTitleField setHidden:YES];
}

- (void)foundLocation:(CLLocation *)loc
{
    CLLocationCoordinate2D coord = [loc coordinate];
    
    // Create an instance of BNRMapPoint with the current data
    BNRMapPoint *mp = [[BNRMapPoint alloc] initWithCoordinate:coord title:[locationTitleField text]];

    
    // Add it to the map view
    [worldView addAnnotation:mp];
    
    // Zoom the region to this location
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 500, 500);
    [worldView setRegion:region animated:YES];
    
    // Reset the UI
    [locationTitleField setText:@""];
    [activityIndicator stopAnimating];
    [locationTitleField setHidden:NO];
    [locationManager stopUpdatingLocation];
}

- (void)changeMapType
{
    int option = [segmentControl selectedSegmentIndex];
    NSLog(@"%d",option);
    [[NSUserDefaults standardUserDefaults] setInteger:option forKey:WhereamiMapTypePrefKey];
    switch (option) {
        case 0:
            [worldView setMapType:MKMapTypeStandard];
            break;
        case 1:
            [worldView setMapType:MKMapTypeHybrid];
            break;
        case 2:
            [worldView setMapType:MKMapTypeSatellite];
            break;
        default:
            break;
    }
}






@end
