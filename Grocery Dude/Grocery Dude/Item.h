//
//  Item.h
//  Grocery Dude
//
//  Created by Long Vinh Nguyen on 12/9/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Item : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) NSData * photoData;
@property (nonatomic, retain) NSNumber * listed;
@property (nonatomic, retain) NSNumber * collected;

@end
