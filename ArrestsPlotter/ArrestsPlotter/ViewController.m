//
//  ViewController.m
//  ArrestsPlotter
//
//  Created by Long Vinh Nguyen on 5/17/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <ASIHTTPRequest.h>
#import "MyLocation.h"
#import <MBProgressHUD.h>
#import <QuartzCore/QuartzCore.h>

#define METERS_PER_MILE 1609.344

@interface ViewController ()

@property (nonatomic, strong) MBProgressHUD *hudView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_mapView showsUserLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)plotCrimePositions:(NSData *)responseData
{
    for (id<MKAnnotation> annotation in _mapView.annotations) {
        [_mapView removeAnnotation:annotation];
    }
    
    NSDictionary *root = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
    NSArray *data = [root objectForKey:@"data"];
    
    for (NSArray *row in data) {
        NSNumber *latitude = row[22][1];
        NSNumber *longtitude = row [22][2];
        NSString *crimeDescription = row[18];
        NSString *address = row[14];
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = latitude.doubleValue;
        coordinate.longitude = longtitude.doubleValue;
        MyLocation *annotation = [[MyLocation alloc] initWithName:crimeDescription address:address coordinate:coordinate];
        [_mapView addAnnotation:annotation];
    }
}

- (IBAction)showUserLocation:(id)sender {
    [_mapView showsUserLocation];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(_mapView.userLocation.coordinate, 1000, 1000);
    region = [_mapView regionThatFits:region];
    [_mapView setRegion:region animated:YES];

}

- (IBAction)refreshTapped:(id)sender {    
    // 1
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 39.281416;
    zoomLocation.longitude = -76.580806;
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5 * METERS_PER_MILE, 0.5 *METERS_PER_MILE);
    [_mapView setDelegate:self];
    [_mapView setRegion:region animated:YES];
    
    MKCoordinateRegion mapRegion = [_mapView region];
    CLLocationCoordinate2D centerLocation = mapRegion.center;
    
    // 2
    NSString *jsonFile = [[NSBundle mainBundle] pathForResource:@"command" ofType:@"json"];
    NSString *formatString = [NSString stringWithContentsOfFile:jsonFile encoding:NSUTF8StringEncoding error:nil];
    NSString *json = [NSString stringWithFormat:formatString,
                      centerLocation.latitude, centerLocation.longitude, 0.5*METERS_PER_MILE];
    
    // 3
    NSURL *url = [NSURL URLWithString:@"http://data.baltimorecity.gov/api/views/INLINE/rows.json?method=index"];
    
    // 4
    ASIHTTPRequest *_request = [ASIHTTPRequest requestWithURL:url];
    __weak ASIHTTPRequest *request = _request;
    
    request.requestMethod = @"POST";
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request appendPostData:[json dataUsingEncoding:NSUTF8StringEncoding]];
    // 5
    [request setDelegate:self];
    [request setCompletionBlock:^{
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_hudView removeFromSuperview];
        });
//        NSString *responseString = [request responseString];
//        NSLog(@"Response: %@", responseString);
        [self plotCrimePositions:request.responseData];
    }];
    [request setFailedBlock:^{
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_hudView removeFromSuperview];
        });
        NSError *error = [request error];
        NSLog(@"Error: %@", error.localizedDescription);
    }];
    [request startAsynchronous];
    _hudView = [[MBProgressHUD alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
    _hudView.animationType = MBProgressHUDModeCustomView;
    _hudView.labelText = @"Requesting arrests ...";
    [_hudView setCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_twitter"]]];
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iphonebg"]];
    backgroundView.frame = _hudView.frame;
//    _hudView.alpha = 0.5;
    [_hudView addSubview:backgroundView];
    [_hudView sendSubviewToBack:backgroundView];
    [self.view addSubview:_hudView];
    [_hudView show:YES];
}

#pragma mark - MKMapView delegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *identifier = @"MyLocation";
    if ([annotation isKindOfClass:[MyLocation class]]) {
        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (!annotationView) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            [annotationView setImage:[UIImage imageNamed:@"arrest"]];
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        } else {
            annotationView.annotation =annotation;
        }
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    VLog(@"Tapped the location");
    MyLocation *myLocation = (MyLocation *)view.annotation;
    NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving};
    [myLocation.mapItem openInMapsWithLaunchOptions:launchOptions];
}


- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    for (MKAnnotationView *view in views) {
        CABasicAnimation *dropFromTop = [CABasicAnimation animationWithKeyPath:@"position"];
        dropFromTop.duration = 0.5;
        dropFromTop.fromValue = [NSValue valueWithCGPoint:CGPointMake(view.center.x, view.center.y - 500)];
        dropFromTop.toValue = [NSValue valueWithCGPoint:view.center];
        [view.layer addAnimation:dropFromTop forKey:@"dropFromTop"];

    }
}














@end
