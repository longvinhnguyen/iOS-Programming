//
//  CoreDataImporter.m
//  Grocery Dude
//
//  Created by Long Vinh Nguyen on 12/21/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "CoreDataImporter.h"

@implementation CoreDataImporter
#define debug 1

+ (void)saveContext:(NSManagedObjectContext *)context
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [context performBlockAndWait:^{
        if ([context hasChanges]) {
            NSError * error =nil;
            if ([context save:&error]) {
                NSLog(@"CoreDataImporter SAVED changes to persistent store");
            } else {
                NSLog(@"CoreDataImporter SAVED changes to persistent store %@", error.localizedDescription);
            }
        }
    }];
}

- (instancetype)initWithUniqueAttributes:(NSDictionary *)uniqueAttributes
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    if (self = [super init]) {
        self.entitiesWithUniqueAttribues = uniqueAttributes;
        if (self.entitiesWithUniqueAttribues) {
            return self;
        } else {
            NSLog(@"FAILED to initialize CoreDataImporter: entitiesWithUniqueAttributes is nil");
        }
    }
    
    return nil;
}

- (NSString *)uniqueAttributeForEntity:(NSString *)entity
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return self.entitiesWithUniqueAttribues[entity];
}

- (NSManagedObject *)existingObjectInContext:(NSManagedObjectContext *)context forEntity:(NSString *)entity withUniqueAttributeValue:(NSString *)uniqueAttributeValue
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    NSString *uniqueAttribute = [self uniqueAttributeForEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K==%@", uniqueAttribute, uniqueAttributeValue];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entity];
    fetchRequest.predicate = predicate;
    fetchRequest.fetchLimit = 1;
    NSError *error;
    NSArray *fetchObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"Error : %@", error.localizedDescription);
    }
    
    return [fetchObjects lastObject];
}

- (NSManagedObject *)insertUniqueObjectInTargetEntity:(NSString *)entity uniqueAttributeValue:(NSString *)uniqueAttributeValue attributeValues:(NSDictionary *)attributeValues inContext:(NSManagedObjectContext *)context
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    NSString *uniqueAttribute = [self uniqueAttributeForEntity:entity];
    if (uniqueAttributeValue.length > 0) {
        NSManagedObject *existingObject = [self existingObjectInContext:context forEntity:entity withUniqueAttributeValue:uniqueAttributeValue];
        if (existingObject) {
            NSLog(@"%@ object with %@ value '%@' already exists", existingObject, uniqueAttribute, uniqueAttributeValue);
            return existingObject;
        } else {
            NSManagedObject *newObject = [NSEntityDescription insertNewObjectForEntityForName:entity inManagedObjectContext:context];
            [newObject setValuesForKeysWithDictionary:attributeValues];
            NSLog(@"Created %@ object with %@ '%@'", entity, uniqueAttribute, uniqueAttributeValue);
            return newObject;
        }
        
    } else {
        NSLog(@"Skipped %@ object creation: unique attribute value is 0 length", entity);
    }
    return nil;
}

- (NSManagedObject *)insertBasicObjectInTargetEntity:(NSString *)entity targetEntityAttribute:(NSString *)targetEntityAttribute sourceXMLAttribute:(NSString *)sourceXMLAttribute attributeDict:(NSDictionary *)attributeDict context:(NSManagedObjectContext *)context
{
    NSArray *attributes = [NSArray arrayWithObject:targetEntityAttribute];
    NSArray *values = [NSArray arrayWithObject:[attributeDict valueForKey:sourceXMLAttribute]];
    NSDictionary *attributeValues = [NSDictionary dictionaryWithObjects:values forKeys:attributes];
    
    return [self insertUniqueObjectInTargetEntity:entity uniqueAttributeValue:[attributeDict valueForKey:sourceXMLAttribute] attributeValues:attributeValues inContext:context];
}


@end
