//
//  Item_Photo.h
//  Grocery Dude
//
//  Created by Long Vinh Nguyen on 12/30/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Item;

@interface Item_Photo : NSManagedObject

@property (nonatomic, retain) NSData * data;
@property (nonatomic, retain) Item *item;

@end
