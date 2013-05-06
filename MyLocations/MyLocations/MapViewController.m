//
//  MapViewController.m
//  MyLocations
//
//  Created by Long Vinh Nguyen on 5/2/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "MapViewController.h"
#import "Location.h"
#import "LocationDetailsViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController
{
    NSArray *locations;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextDidChange:) name:NSManagedObjectContextObjectsDidChangeNotification object:self.managedObjectContext];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self updateLocations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"EditLocation"]) {
        UINavigationController *nav = (UINavigationController *)segue.destinationViewController;
        LocationDetailsViewController *lvc = (LocationDetailsViewController *)nav.topViewController;
        lvc.managedObjectContext = _managedObjectContext;
        Location *locationToEdit = [locations objectAtIndex:((UIButton *)sender).tag];
        lvc.locationToEdit = locationToEdit;
    }
}

- (MKCoordinateRegion)regionFromAnnotations:(NSArray *)annotations
{
    MKCoordinateRegion region;
    
    if (annotations.count == 0) {
        region = MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.coordinate, 1000, 1000);
    } else if (annotations.count == 1) {
        id<MKAnnotation> annotation = [annotations lastObject];
        region = MKCoordinateRegionMakeWithDistance([annotation coordinate], 1000, 1000);
    } else {
        CLLocationCoordinate2D topLeftCoord;
        topLeftCoord.latitude = 90;
        topLeftCoord.longitude = -180;
        
        CLLocationCoordinate2D bottomRightCoord;
        bottomRightCoord.latitude = -90;
        bottomRightCoord.longitude = 180;
        
        for (id<MKAnnotation>annotation in annotations) {
            topLeftCoord.latitude = fmin(topLeftCoord.latitude, [annotation coordinate].latitude);
            topLeftCoord.longitude = fmax(topLeftCoord.longitude, [annotation coordinate].longitude);
            bottomRightCoord.latitude = fmax(bottomRightCoord.latitude, [annotation coordinate].latitude);
            bottomRightCoord.longitude = fmin(bottomRightCoord.longitude, [annotation coordinate].longitude);
        }
        
        const double extraSpace = 1.1;
        region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) / 2.0;
        region.center.longitude = topLeftCoord.longitude - (topLeftCoord.longitude - bottomRightCoord.longitude) / 2.0;
        region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * extraSpace;
        region.span.longitudeDelta = fabs(topLeftCoord.longitude - bottomRightCoord.longitude) *extraSpace;
    }
    return [self.mapView regionThatFits:region];
}

- (void)updateLocations
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Location" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *foundObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (foundObjects == nil) {
        FATAL_CORE_DATA_ERROR(error);
        return;
    }
    
    if (locations != nil) {
        [self.mapView removeAnnotations:locations];
    }
    
    locations = foundObjects;
    [self.mapView addAnnotations:locations];
}

- (void)showLocationsDetails:(id)sender
{
    [self performSegueWithIdentifier:@"EditLocation" sender:sender];
}

- (void)contextDidChange:(NSNotification *)nc
{
//    if ([self isViewLoaded]) {
//        [self updateLocations];
//    }
//    VLog(@"User Info: %@",[[nc.userInfo objectForKey:NSUpdatedObjectsKey] class]);
    if ([nc.userInfo objectForKey:NSUpdatedObjectsKey]) {
        Location *updatedLocation = [[nc.userInfo objectForKey:NSUpdatedObjectsKey] anyObject];
        VLog(@"Location: %@", updatedLocation);
        [self.mapView removeAnnotation:updatedLocation];
        [self.mapView addAnnotation:updatedLocation];
        VLog(@"Update mapPinAnnotationView with new info");
    } else if ([nc.userInfo objectForKey:NSDeletedObjectsKey]) {
        Location *deletedLocation = [[nc.userInfo objectForKey:NSDeletedObjectsKey] anyObject];
        [self.mapView removeAnnotation:deletedLocation];
    } else {
        Location *newLocation = [[nc.userInfo objectForKey:NSInsertedObjectsKey] anyObject];
        [self.mapView addAnnotation:newLocation];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSManagedObjectContextObjectsDidChangeNotification object:self.managedObjectContext];
}

#pragma mark - MKMapView delegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[Location class]]) {
        static NSString *identifier = @"Location";
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            annotationView.animatesDrop = NO;
            annotationView.pinColor = MKPinAnnotationColorGreen;
            
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [rightButton addTarget:self action:@selector(showLocationsDetails:) forControlEvents:UIControlEventTouchUpInside];
            annotationView.rightCalloutAccessoryView = rightButton;
        } else {
            annotationView.annotation = annotation;
        }
        
        UIButton *button = (UIButton *)(annotationView.rightCalloutAccessoryView);
        button.tag = [locations indexOfObject:(Location *)annotation];
        return annotationView;
    }
    return nil;
}


#pragma mark - MapViewController delegate

- (IBAction)showUser
{
    VLog(@"Zoom user location 1000 meters");
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.coordinate, 1000, 1000);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}

- (IBAction)showLocations
{
    MKCoordinateRegion region = [self regionFromAnnotations:locations];
    [self.mapView setRegion:region animated:YES];
}


@end
