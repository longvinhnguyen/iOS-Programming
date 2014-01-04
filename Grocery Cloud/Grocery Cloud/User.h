//
//  User.h
//  Grocery Cloud
//
//  Created by Long Vinh Nguyen on 1/3/14.
//  Copyright (c) 2014 Tim Roadley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "StackMob.h"


@interface User : SMUserManagedObject

@property (nonatomic, retain) NSDate * createddate;
@property (nonatomic, retain) NSDate * lastmoddate;
@property (nonatomic, retain) NSString * user_id;
@property (nonatomic, retain) NSString * username;
- (id)initWithNewUserInContext:(NSManagedObjectContext *)context;

@end
