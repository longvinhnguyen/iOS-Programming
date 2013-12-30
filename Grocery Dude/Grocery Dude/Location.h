//
//  Location.h
//  Grocery Dude
//
//  Created by Long Vinh Nguyen on 12/30/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Location : NSManagedObject

@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSDate * modified;

@end
