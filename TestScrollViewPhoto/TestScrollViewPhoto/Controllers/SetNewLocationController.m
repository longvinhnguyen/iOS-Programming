//
//  SetNewLocationController.m
//  TestScrollViewPhoto
//
//  Created by VisiKard MacBook Pro on 7/31/13.
//  Copyright (c) 2013 VisiKard MacBook Pro. All rights reserved.
//

#import "SetNewLocationController.h"

#define RADIUS_LEVEL_1      1600
#define RADIUS_LEVEL_5      RADIUS_LEVEL_1 * 5
#define RADIUS_LEVEL_DEFAULT      RADIUS_LEVEL_1 * 10
#define RADIUS_LEVEL_20      RADIUS_LEVEL_1 * 20
#define RADIUS_LEVEL_50     RADIUS_LEVEL_1 * 50

#define ZOOM_LEVEL_1        13.5
#define ZOOM_LEVEL_5        11.15
#define ZOOM_LEVEL_DEFAULT        10.15
#define ZOOM_LEVEL_20        9.2
#define ZOOM_LEVEL_50        7.85

#define EPSILON         0.000001

@interface SetNewLocationController ()

@end

@implementation SetNewLocationController

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
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
                                                            longitude:151.20
                                                                 zoom:15];
    _mapView.myLocationEnabled = YES;
    _mapView.delegate = self;
    _mapView.camera = camera;
    NSLog(@"Start zooming");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)setMileButtonTapped:(UIButton *)sender
{
    float radius = 0.0f;
    CLLocationCoordinate2D coordinate = [_mapView.projection coordinateForPoint:_mapView.center];

    switch (sender.tag) {
        case 1:
            [self zoomInCoordinate:coordinate atLevel:ZOOM_LEVEL_1];
            break;
        case 5:
            [self zoomInCoordinate:coordinate atLevel:ZOOM_LEVEL_5];
            break;
        case 10:
            [self zoomInCoordinate:coordinate atLevel:ZOOM_LEVEL_DEFAULT];
            break;
        case 20:
            [self zoomInCoordinate:coordinate atLevel:ZOOM_LEVEL_20];
            radius = RADIUS_LEVEL_20;
            break;
        case 50:
            [self zoomInCoordinate:coordinate atLevel:ZOOM_LEVEL_50];
            break;

        default:
            break;
    }
}

- (void)zoomInCoordinate:(CLLocationCoordinate2D)coordinate atLevel:(float)zoomLevel
{
    GMSCameraPosition *camera;
    CGFloat radius = 0.0f;
    camera = [GMSCameraPosition cameraWithLatitude:coordinate.latitude longitude:coordinate.longitude zoom:zoomLevel];
    _mapView.camera = camera;
    
    if (fabs(zoomLevel - ZOOM_LEVEL_1) <= EPSILON) {
        radius = RADIUS_LEVEL_1;
    } else if (fabs(zoomLevel - ZOOM_LEVEL_5) <= EPSILON) {
        radius = RADIUS_LEVEL_5;
    } else if (fabs(zoomLevel - ZOOM_LEVEL_DEFAULT) <= EPSILON) {
        radius = RADIUS_LEVEL_DEFAULT;
    } else if (fabs(zoomLevel - ZOOM_LEVEL_20) <= EPSILON) {
        radius = RADIUS_LEVEL_20;
    } else if (fabs(zoomLevel - ZOOM_LEVEL_50) <= EPSILON) {
        radius = RADIUS_LEVEL_50;
    }
    
    [self drawCircleCenterWithRadius:radius coordinate:coordinate];
}

- (void)drawCircleCenterWithRadius:(CGFloat)radius coordinate:(CLLocationCoordinate2D)coordinate
{
    // If the center circle overlay still inside the define region radius -> don't update it
//    if ([self isCenterCircleInsideMapCenterRegion]) {
//        return;
//    }
    
    [_mapView clear];
    GMSCircle *circle = [GMSCircle circleWithPosition:coordinate radius:radius];
    circle.strokeWidth = 7.0f;
    circle.strokeColor = [UIColor lightGrayColor];
    circle.fillColor = [UIColor colorWithWhite:0.0f alpha:0.1];
    circle.map = _mapView;
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = coordinate;
    marker.map = _mapView;
    
    // set place mark
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:[[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude] completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!error) {
            CLPlacemark *placemark = [placemarks lastObject];
            NSLog(@"Placemark %@", placemark);
            marker.snippet = placemark.name;
            marker.title = placemark.country;
        }
    }];
}

- (BOOL)isCenterCircleInsideMapCenterRegion
{
    return YES;
}

#pragma mark - GoogleMapView delegate
- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position
{
    NSLog(@"Zoom Level:%f", position.zoom);
}



@end
