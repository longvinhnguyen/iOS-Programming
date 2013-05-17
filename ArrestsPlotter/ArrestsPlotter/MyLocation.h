//
//  MyLocation.h
//  ArrestsPlotter
//
//  Created by Long Vinh Nguyen on 5/17/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyLocation : NSObject<MKAnnotation>

- (id)initWithName:(NSString *)name address:(NSString *)address coordinate:(CLLocationCoordinate2D)coordinate;
- (MKMapItem *)mapItem;

@end
