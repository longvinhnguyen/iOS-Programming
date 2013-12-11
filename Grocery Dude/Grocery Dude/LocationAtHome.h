//
//  LocationAtHome.h
//  Grocery Dude
//
//  Created by Long Vinh Nguyen on 12/11/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Location.h"

@class Item;

@interface LocationAtHome : Location

@property (nonatomic, retain) NSString * storedIn;
@property (nonatomic, retain) Item *items;

@end
