//
//  LocationAtShop.h
//  Grocery Cloud
//
//  Created by Long Vinh Nguyen on 1/3/14.
//  Copyright (c) 2014 Tim Roadley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Location.h"

@class Item;

@interface LocationAtShop : Location

@property (nonatomic, retain) NSString * aisle;
@property (nonatomic, retain) NSString * locationatshop_id;
@property (nonatomic, retain) NSSet *items;
@end

@interface LocationAtShop (CoreDataGeneratedAccessors)

- (void)addItemsObject:(Item *)value;
- (void)removeItemsObject:(Item *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end
