//
//  MapViewController.h
//  MyLocations
//
//  Created by Long Vinh Nguyen on 5/2/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapViewController : UIViewController<MKMapViewDelegate>

@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic,strong) IBOutlet MKMapView *mapView;

- (IBAction)showUser;
- (IBAction)showLocations;

@end
