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


#pragma mark - DEEP COPY
- (NSString *)objectInfo:(NSManagedObject *)object
{
    if (!object) {
        return nil;
    }
    
    NSString *entity = object.entity.name;
    NSString *uniqueAttribute = [self uniqueAttributeForEntity:entity];
    NSString *uniqueAttributeValue = [object valueForKey:uniqueAttribute];
    
    return [NSString stringWithFormat:@"%@ '%@'", entity, uniqueAttributeValue];
}

- (NSArray *)arrayForEntity:(NSString *)entity inContext:(NSManagedObjectContext *)context withPredicate:(NSPredicate *)predicate
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entity];
    request.fetchBatchSize = 50;
    request.predicate = predicate;
    NSError *error;
    NSArray *array = [context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"ERROR fetching objects: %@", error.localizedDescription);
    }
    
    return array;
}

- (NSManagedObject *)copyUniqueObject:(NSManagedObject *)object toContext:(NSManagedObjectContext *)targetContext
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }

    // SKIP copying object with missing info
    if (!object || !targetContext) {
        NSLog(@"FAILED to copy %@ to context %@", [self objectInfo:object], targetContext);
        return nil;
    }
    
    // PREPARE variables
    NSString *entity = object.entity.name;
    NSString *uniqueAttribute = [self uniqueAttributeForEntity:entity];
    NSString *uniqueAttributeValue = [object valueForKey:uniqueAttribute];
    
    if (uniqueAttributeValue.length > 0) {
        // PREPARE attributes to copy
        NSMutableDictionary *attributeValuesToCopy = [NSMutableDictionary new];
        for (NSString *attribute in object.entity.attributesByName) {
            if ([[object valueForKey:attribute] copy]) {
                [attributeValuesToCopy setObject:[[object valueForKey:attribute] copy] forKey:attribute];
            }
        }
        
        // COPY object
        NSManagedObject *copiedObject = [self insertUniqueObjectInTargetEntity:entity uniqueAttributeValue:uniqueAttributeValue attributeValues:attributeValuesToCopy inContext:targetContext];
        return copiedObject;
    }
    return nil;
}

- (void)etablishToOneRelationship:(NSString *)relationshipName fromObject:(NSManagedObject *)object toObject:(NSManagedObject *)relatedObject
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    // SKIP etablishing a relationship with missing info
    if (!relationshipName || !object || !relatedObject) {
        NSLog(@"SKIPPED establishing To-One relationship '%@' between %@ and %@", relationshipName, [self objectInfo:object], [self objectInfo:relatedObject]);
        NSLog(@"Due to missing info");
        return;
    }
    
    // SKIP etablishing an existing relationship
    NSManagedObject *existingRelationObject = [object valueForKey:relationshipName];
    if (existingRelationObject) {
        return;
    }
    
    // SKIP etablishing to relationship to the wron entity
    NSDictionary *relationships = object.entity.relationshipsByName;
    NSRelationshipDescription *relationship = [relationships objectForKey:relationshipName];
    if (![relatedObject.entity isEqual:relationship.destinationEntity]) {
        NSLog(@"%@ is the of wrong entity to relate to %@", [self objectInfo:object], [self objectInfo:relatedObject]);
        return;
    }
    
    // ETABLISH the relationship
    [object setValue:relatedObject forKey:relationshipName];
    NSLog(@"ETABLISHED %@ relationship from %@ to %@", relationshipName,[self objectInfo:object], [self objectInfo:relatedObject]);
    
    // REMOVE the relationship from memory after it is commited to disk
    [CoreDataImporter saveContext:relatedObject.managedObjectContext];
    [CoreDataImporter saveContext:object.managedObjectContext];
    [object.managedObjectContext refreshObject:object mergeChanges:NO];
    [relatedObject.managedObjectContext refreshObject:object mergeChanges:NO];
}

- (void)etablishOrderedToManyRelationship:(NSString *)relationshipName fromObject:(NSManagedObject *)object withSourceSet:(NSMutableOrderedSet *)sourceSet
{
    if  (!object || !sourceSet || !relationshipName) {
        NSLog(@"SKIPPED establish of an Ordered To-Many relationship from %@", [self objectInfo:object]);
        NSLog(@"Due to missing info");
        return;
    }
    
    NSMutableOrderedSet *copiedSet = [object mutableOrderedSetValueForKey:relationshipName];
    for (NSManagedObject *relatedObject in sourceSet) {
        NSManagedObject *copiedRelatedObject = [self copyUniqueObject:relatedObject toContext:object.managedObjectContext];
        if (copiedRelatedObject) {
            [copiedSet addObject:copiedRelatedObject];
            NSLog(@"A copy of %@ is related via Ordered To-Many '%@' relationship to %@", [self objectInfo:object], relationshipName, [self objectInfo:copiedRelatedObject]);
        }
    }
    
    // REMOVE the relationship from memory after it is commited to disk
    [CoreDataImporter saveContext:object.managedObjectContext];
    [object.managedObjectContext refreshObject:object mergeChanges:NO];
}

- (void)etablishToManyRelationship:(NSString *)relationshipName fromObject:(NSManagedObject *)object withSourceSet:(NSMutableSet *)sourceSet
{
    if  (!object || !sourceSet || !relationshipName) {
        NSLog(@"SKIPPED establish of an Ordered To-Many relationship from %@", [self objectInfo:object]);
        NSLog(@"Due to missing info");
        return;
    }
    
    NSMutableSet *copiedSet = [object mutableSetValueForKey:relationshipName];
    for (NSManagedObject *relatedObject in sourceSet) {
        NSManagedObject *copiedRelatedObject = [self copyUniqueObject:relatedObject toContext:object.managedObjectContext];
        if (copiedRelatedObject) {
            [copiedSet addObject:copiedRelatedObject];
            NSLog(@"A copy of %@ is related via Ordered To-Many '%@' relationship to %@", [self objectInfo:object], relationshipName, [self objectInfo:copiedRelatedObject]);
        }
    }
    
    // REMOVE the relationship from memory after it is commited to disk
    [CoreDataImporter saveContext:object.managedObjectContext];
    [object.managedObjectContext refreshObject:object mergeChanges:NO];
}

- (void)copyRelationshipsFromObject:(NSManagedObject *)sourceObject toContext:(NSManagedObjectContext *)targetContext
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    // SKIP establishing relationships with missing info
    if (!sourceObject || !targetContext) {
        NSLog(@"FAILED to copy relationships from '%@' to context '%@'", [self objectInfo:sourceObject], targetContext);
    }
    
    // SKIP establishing relationships from nil objects
    NSManagedObject *copiedObject =[self copyUniqueObject:sourceObject toContext:targetContext];
    if (!copiedObject) {
        return;
    }
    
    // COPY relationships
    NSDictionary *relationships = [sourceObject.entity relationshipsByName];
    for (NSString *relationshipName in relationships) {
        NSRelationshipDescription *relationship = [relationships valueForKey:relationshipName];
        if (relationship.isToMany && relationship.isOrdered) {
            // COPY To-Many Ordered
            NSMutableOrderedSet *sourceSet = [sourceObject mutableOrderedSetValueForKey:relationshipName];
            [self etablishOrderedToManyRelationship:relationshipName fromObject:copiedObject withSourceSet:sourceSet];
        } else if (relationship.isToMany && !relationship.isOrdered) {
            NSMutableSet *sourceSet = [sourceObject mutableSetValueForKey:relationshipName];
            [self etablishToManyRelationship:relationshipName fromObject:copiedObject withSourceSet:sourceSet];
        } else {
            // COPY To-One
            NSManagedObject *relatedSourceObject = [sourceObject valueForKey:relationshipName];
            NSManagedObject *copiedRelatedSourceObject = [self copyUniqueObject:relatedSourceObject toContext:targetContext];
            [self etablishToOneRelationship:relationshipName fromObject:copiedObject toObject:copiedRelatedSourceObject];
        }
    }
}

- (void)deepCopyEntities:(NSArray *)entities fromContext:(NSManagedObjectContext *)sourceContext toContext:(NSManagedObjectContext *)targetContext
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    for (NSString *entity in entities) {
        NSLog(@"COPY %@ objects to target context...", entity);
        NSArray *sourceObjects = [self arrayForEntity:entity inContext:sourceContext withPredicate:nil];
        for (NSManagedObject *sourceObject in sourceObjects) {
            @autoreleasepool {
                [self copyUniqueObject:sourceObject toContext:targetContext];
                [self copyRelationshipsFromObject:sourceObject toContext:targetContext];
            }
        }
    }
}

@end
