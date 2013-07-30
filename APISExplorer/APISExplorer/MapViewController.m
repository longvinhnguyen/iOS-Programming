//
//  MapViewController.m
//  APISExplorer
//
//  Created by Long Vinh Nguyen on 6/11/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "MapViewController.h"
#import "ViewController.h"
#import "Venue.h"
#import <AFNetworking/AFHTTPClient.h>
#import <AFNetworking/AFJSONRequestOperation.h>
#import "VenueDetailController.h"

#define HEIGHT_TOOLBAR_VIEW_CONTROLLER 44

@interface TestTileLayer : GMSSyncTileLayer

@end


@implementation TestTileLayer

- (UIImage *)tileForX:(NSUInteger)x y:(NSUInteger)y zoom:(NSUInteger)zoom
{
    if (x % 2) {
        return [UIImage imageNamed:@"australia"];
    } else {
        return kGMSTileLayerNoTile;
    }
}

@end

@interface MapViewController ()

@end

@implementation MapViewController
{
    GMSMapView *_mapView;
    UIImage *_mapIcon;
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
    // set up toolbar
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem *clearMapButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(clearMapView:)];
    UIBarButtonItem *drawPolyLine = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(drawPolylines:)];
    toolBar.items = @[clearMapButton, drawPolyLine];
    
    // set up map view
    
    _mapView = [GMSMapView mapWithFrame:CGRectMake(0, HEIGHT_TOOLBAR_VIEW_CONTROLLER, WIDTH_IPHONE, HEIGHT_IPHONE - HEIGHT_TOOLBAR_VIEW_CONTROLLER) camera:[GMSCameraPosition cameraWithLatitude:0 longitude:0 zoom:12.5]];
    [_mapView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    _mapView.settings.myLocationButton = YES;
    _mapView.settings.compassButton = YES;
    _mapView.myLocationEnabled = YES;
    _mapView.delegate = self;
    
    GMSCameraUpdate *myLocation = [GMSCameraUpdate setTarget:_mapView.myLocation.coordinate];
    VLog(@"My location: %f %f", _mapView.myLocation.coordinate.latitude, _mapView.myLocation.coordinate.longitude);
    [_mapView moveCamera:myLocation];
    [self.view addSubview:_mapView];
    [self.view addSubview:toolBar];

}



- (void)viewWillAppear:(BOOL)animated
{
    _mapIcon = [UIImage imageNamed:@"home"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - GMSMapViewDelegate
- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
//    GMSGeocoder *geo = [[GMSGeocoder alloc] init];
//    VLog(@"You tapped at %f %f", coordinate.latitude, coordinate.longitude);
//    [geo reverseGeocodeCoordinate:coordinate completionHandler:^(GMSReverseGeocodeResponse *placemark, NSError *error) {
//        if (!error) {
//            VLog(@"%@", [placemark firstResult].addressLine1);
//            GMSMarker *marker = [GMSMarker markerWithPosition:coordinate];
//            marker.title = placemark.firstResult.addressLine1;
//            marker.snippet = [NSString stringWithFormat:@"%@", placemark.firstResult.addressLine2];
//            marker.animated = YES;
//            marker.infoWindowAnchor = CGPointMake(0.5, 0.5);
//            marker.map = _mapView;
//        } else
//            VLog(@"Error %@", error.localizedDescription);
//
//    }];
}

- (void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate
{
//    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:CLLocationCoordinate2DMake(-33.8683, 151.2086) coordinate:coordinate];
//    GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds withPadding:5.0f];
//
//    [_mapView moveCamera:update];
//    [_mapView animateToViewingAngle:30];
    NSString *url = [NSString stringWithFormat:@"comgooglemaps://center=%f,%f",coordinate.latitude,coordinate.longitude];

    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    } else {
        VLog(@"Cannot open google map");
    }
}

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker
{
    VLog(@"Info marker window tapped");
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:STRING_ROOT_URL_REQUEST_GOOLGE_PLACES]];
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    
    Venue *venue = marker.userData;
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:venue.referID forKey:@"reference"];
    [params setValue:GOOGLE_MAP_API_KEY forKey:@"key"];
    [params setValue:@"false" forKey:@"sensor"];
    VLog(@"Params %@", params);
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [client getPath:@"details/json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        VLog(@"Place details =======> %@", responseObject);
        NSDictionary *result = responseObject[@"result"];
        if (result) {
            Venue *venue = [[Venue alloc] init];
            [venue loadDataFromGooglePlaceDetailResponse:result];
            VenueDetailController *vdc = [[VenueDetailController alloc] init];
            vdc.venue = venue;
            vdc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self presentModalViewController:vdc animated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error) {
            SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Error" andMessage: [NSString stringWithFormat:@"%@", error.localizedDescription]];
            [alertView addButtonWithTitle:@"OK" type:SIAlertViewButtonTypeCancel handler:nil];
        }
    }];
    
}



#pragma mark - Actions
- (void)clearMapView:(id)sender
{
    [_mapView clear];
}

- (void)drawPolylines:(id)sender
{
    VLog(@"Call draw Polyline");
    NSArray *markers = _mapView.markers;
    GMSMutablePath *path = [[GMSMutablePath alloc] init];
    if (markers && markers.count > 1) {
        for (GMSMarker *marker in markers) {
            [path addCoordinate:marker.position];
        }
    }
    
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polyline.strokeWidth = 2;
    polyline.strokeColor = [UIColor blueColor];
    polyline.map = _mapView;
}

#pragma mark - ViewController Delegate
- (void)viewController:(ViewController *)controller showVenueOnMap:(Venue *)venue
{
    GMSCameraUpdate *update = [GMSCameraUpdate setCamera:[GMSCameraPosition cameraWithTarget:venue.coordinate zoom:12]];
    [_mapView moveCamera:update];
    GMSMarker *marker = [GMSMarker markerWithPosition:venue.coordinate];
    marker.title = venue.title;
    marker.snippet = venue.detailTitle;
    marker.userData = venue;
    marker.icon = [GMSMarker markerImageWithColor:[UIColor brownColor]];
    marker.animated = YES;
    marker.map = _mapView;
}






@end


