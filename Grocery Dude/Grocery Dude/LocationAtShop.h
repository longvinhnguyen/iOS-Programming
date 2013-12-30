//
//  LocationAtShop.h
//  Grocery Dude
//
//  Created by Long Vinh Nguyen on 12/30/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Location.h"

@class Item;

@interface LocationAtShop : Location

@property (nonatomic, retain) NSString * aisle;
@property (nonatomic, retain) NSSet *items;
@end

@interface LocationAtShop (CoreDataGeneratedAccessors)

- (void)addItemsObject:(Item *)value;
- (void)removeItemsObject:(Item *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end
