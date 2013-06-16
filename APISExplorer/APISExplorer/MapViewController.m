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

}

- (void)viewWillAppear:(BOOL)animated
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"Clear Map" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    VLog(@"Size of view: %f", self.view.bounds.size.height);
    button.frame = CGRectMake(50, self.view.bounds.size.height - 60, 100, 40);
    [button addTarget:self action:@selector(clearMapView:) forControlEvents:UIControlEventTouchUpInside];
    [_mapView addSubview:button];
    
    _mapIcon = [UIImage imageNamed:@"home"];
}

- (void)loadView
{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-37.8131 longitude:144.96298 zoom:12];
    _mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    _mapView.myLocationEnabled = YES;
    _mapView.mapType = kGMSTypeNormal;
    _mapView.delegate = self;
//    _mapView.settings.scrollGestures = NO;
//    _mapView.settings.zoomGestures = NO;
    _mapView.settings.compassButton = YES;
    _mapView.settings.myLocationButton = YES;
    
    self.view = _mapView;
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.title = @"Sydney";
    marker.snippet = @"Australia";
    marker.position = CLLocationCoordinate2DMake(-37.81319, 144.96298);
    marker.icon = [GMSMarker markerImageWithColor:[UIColor blackColor]];
    marker.map = _mapView;
    
    // Add polyline to the map
    GMSMutablePath *path = [[GMSMutablePath alloc] init];
    [path addLatitude:-37.81319 longitude:144.96298];
    [path addLatitude:-31.95288 longitude:115.85734];
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polyline.strokeWidth = 10.0f;
    polyline.strokeColor = [UIColor greenColor];
    polyline.geodesic = YES;
    polyline.map = _mapView;
    
    // Add polygon to the map
    GMSMutablePath *rect = [[GMSMutablePath alloc] init];
    [rect addCoordinate:CLLocationCoordinate2DMake(37.35, -122.0)];
    [rect addCoordinate:CLLocationCoordinate2DMake(37.45, -122.0)];
    [rect addCoordinate:CLLocationCoordinate2DMake(37.45, -122.2)];
    [rect addCoordinate:CLLocationCoordinate2DMake(37.35, -122.2)];
    
    GMSPolygon *polygon = [GMSPolygon polygonWithPath:rect];
    polygon.fillColor = [UIColor colorWithRed:0.25 green:0 blue:0 alpha:0.05];
    polygon.strokeColor = [UIColor blackColor];
    polygon.strokeWidth = 2;
    polygon.map = _mapView;
    
    _mapView.camera = [GMSCameraPosition cameraWithLatitude:37.35 longitude:-122.0 zoom:12];
    
    // Add circle to the map
    CLLocationCoordinate2D circleCenter = CLLocationCoordinate2DMake(37.75, -122.0);
    GMSCircle *circ = [GMSCircle circleWithPosition:circleCenter radius:1000];
    circ.fillColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    circ.strokeColor = [UIColor redColor];
    circ.strokeWidth = 5.0f;
    circ.map = _mapView;
    
    // Add overlay to the map
    CLLocationCoordinate2D newark = CLLocationCoordinate2DMake(40.742, -74.174);
    UIImage *icon = [UIImage imageNamed:@"newark_nj_1922.jpg"];
    GMSGroundOverlay *overlay = [GMSGroundOverlay groundOverlayWithPosition:newark icon:icon];
    overlay.bearing = 0;
    overlay.zoomLevel = 13.6;
    overlay.map = _mapView;
    overlay.tappable = YES;

    
    _mapView.camera = [GMSCameraPosition cameraWithLatitude:40.742 longitude:-74.174 zoom:12];
    
    // Add Tile Layer
//    NSInteger floor = 1;
//    GMSTileURLConstructor urls = ^(NSUInteger x, NSUInteger y, NSUInteger zoom) {
//        NSString *url = [NSString stringWithFormat:@"http://www.example.com/floorplans/L%d_%d_%d_%d.png", floor, zoom, x, y];
//        VLog(@"URL :%@",url);
//        return [NSURL URLWithString:url];
//    };
//    
//    GMSURLTileLayer *layer = [GMSURLTileLayer tileLayerWithURLConstructor:urls];
    
//    GMSTileLayer *layer = [[TestTileLayer alloc] init];
    
    // Display on the map at a specific zIndex
//    layer.zIndex = 100;
//    layer.map = _mapView;
    
    // Camera postion
    GMSCameraPosition *sysdney = [GMSCameraPosition cameraWithLatitude:-33.8683 longitude:151.2086 zoom:6 bearing:30 viewingAngle:45];
    [_mapView setCamera:sysdney];
    
    
    // Zoom in one zoom level
    GMSCameraUpdate *zoomCamera = [GMSCameraUpdate zoomIn];
    [_mapView animateWithCameraUpdate:zoomCamera];
    
    // Center the camera on Vancouver, Canada
    CLLocationCoordinate2D vancouver = CLLocationCoordinate2DMake(49.26, -123.11);
    GMSCameraUpdate *vancouverCam = [GMSCameraUpdate setTarget:vancouver];
    [_mapView animateWithCameraUpdate:vancouverCam];
    
    // Move the camera 100 points down, and 200 points to the right
//    GMSCameraUpdate *downwards = [GMSCameraUpdate scrollByX:100 Y:200];
//    [_mapView animateWithCameraUpdate:downwards];
    
    CLLocationCoordinate2D calgary =  CLLocationCoordinate2DMake(51.05, -144.05);
    GMSCoordinateBounds *bounds;
    bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:vancouver coordinate:calgary];
    GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds withPadding:50.0f];
    [_mapView animateWithCameraUpdate:update];
    
//    [_mapView animateToViewingAngle:45];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - GMSMapViewDelegate
- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    GMSGeocoder *geo = [[GMSGeocoder alloc] init];
    VLog(@"You tapped at %f %f", coordinate.latitude, coordinate.longitude);
    [geo reverseGeocodeCoordinate:coordinate completionHandler:^(GMSReverseGeocodeResponse *placemark, NSError *error) {
        if (!error) {
            VLog(@"%@", [placemark firstResult].addressLine1);
            GMSMarker *marker = [GMSMarker markerWithPosition:coordinate];
            marker.title = placemark.firstResult.addressLine1;
            marker.snippet = [NSString stringWithFormat:@"%@", placemark.firstResult.addressLine2];
            marker.animated = YES;
//            marker.icon = _mapIcon;
            marker.infoWindowAnchor = CGPointMake(0.5, 0.5);
            marker.map = _mapView;
        } else
            VLog(@"Error %@", error.localizedDescription);

    }];
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



#pragma mark - Actions
- (void)clearMapView:(id)sender
{
    [_mapView clear];
}

#pragma mark - ViewController Delegate
- (void)viewController:(ViewController *)controller showVenueOnMap:(Venue *)venue
{
    GMSCameraUpdate *update = [GMSCameraUpdate setCamera:[GMSCameraPosition cameraWithTarget:venue.coordinate zoom:12]];
    [_mapView moveCamera:update];
    GMSMarker *marker = [GMSMarker markerWithPosition:venue.coordinate];
    marker.title = venue.title;
    marker.snippet = venue.detailTitle;
    marker.icon = [GMSMarker markerImageWithColor:[UIColor brownColor]];
    marker.map = _mapView;
}






@end


