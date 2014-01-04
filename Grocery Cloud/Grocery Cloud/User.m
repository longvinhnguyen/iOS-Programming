//
//  User.m
//  Grocery Cloud
//
//  Created by Long Vinh Nguyen on 1/3/14.
//  Copyright (c) 2014 Tim Roadley. All rights reserved.
//

#import "User.h"


@implementation User

@dynamic createddate;
@dynamic lastmoddate;
@dynamic user_id;
@dynamic username;

- (id)initWithNewUserInContext:(NSManagedObjectContext *)context
{
    self = [super initWithEntityName:@"User" insertIntoManagedObjectContext:context];
    return self;
}

@end
