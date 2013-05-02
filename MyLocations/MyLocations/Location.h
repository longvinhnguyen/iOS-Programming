//
//  Location.h
//  MyLocations
//
//  Created by Long Vinh Nguyen on 4/30/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Location : NSManagedObject<MKAnnotation>

@property (nonatomic) double latitude;
@property (nonatomic) double longtitude;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSString * locationDescription;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) CLPlacemark* placemark;

@end
