//
//  Deduplicator.h
//  Grocery Dude
//
//  Created by Long Vinh Nguyen on 12/30/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Deduplicator : NSObject

+ (void)deDuplicateEntityWithName:(NSString *)entityName withUniqueAttributeName:(NSString *)uniqueAttributeName withImportContext:(NSManagedObjectContext *)importContext;

@end
