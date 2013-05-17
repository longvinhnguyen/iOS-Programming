//
//  MyLocation.m
//  ArrestsPlotter
//
//  Created by Long Vinh Nguyen on 5/17/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "MyLocation.h"
#import <AddressBook/AddressBook.h>

@interface MyLocation()

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end

@implementation MyLocation

- (id)initWithName:(NSString *)name address:(NSString *)address coordinate:(CLLocationCoordinate2D)coordinate
{
    if (self = [super init]) {
        if ([name isKindOfClass:[NSString class]]) {
            self.name = name;
        } else {
            self.name = @"Unknown Charge";
        }
        self.address = address;
        self.coordinate = coordinate;
    }
    return self;
}

- (NSString *)title
{
    return _name;
}

- (NSString *)subtitle
{
    return _address;
}

- (CLLocationCoordinate2D)coordinate
{
    return _coordinate;
}

- (MKMapItem *)mapItem
{
    NSDictionary *addressDict = [NSDictionary dictionaryWithObject:_address forKey:(NSString *)kABPersonAddressStreetKey];
    MKPlacemark *placeMark = [[MKPlacemark alloc] initWithCoordinate:self.coordinate addressDictionary:addressDict];
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placeMark];
    return mapItem;
}






@end
