//
//  Test.h
//  EasyiCloud
//
//  Created by Long Vinh Nguyen on 1/2/14.
//  Copyright (c) 2014 Home Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Test : NSManagedObject

@property (nonatomic, retain) NSDate * modified;
@property (nonatomic, retain) NSString * device;
@property (nonatomic, retain) NSString * someValue;

@end
