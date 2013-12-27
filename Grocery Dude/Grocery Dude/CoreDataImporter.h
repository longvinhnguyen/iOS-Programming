//
//  CoreDataImporter.h
//  Grocery Dude
//
//  Created by Long Vinh Nguyen on 12/21/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CoreDataImporter : NSObject

@property (nonatomic, strong) NSDictionary *entitiesWithUniqueAttribues;

+ (void)saveContext:(NSManagedObjectContext *)context;
- (instancetype)initWithUniqueAttributes:(NSDictionary *)uniqueAttributes;
- (NSManagedObject *)insertUniqueObjectInTargetEntity:(NSString *)entity uniqueAttributeValue:(NSString *)uniqueAttributeValue attributeValues:(NSDictionary *)attributeValues inContext:(NSManagedObjectContext *)context;
- (NSManagedObject *)insertBasicObjectInTargetEntity:(NSString *)entity targetEntityAttribute:(NSString *)targetEntityAttribute sourceXMLAttribute:(NSString *)sourceXMLAttribute attributeDict:(NSDictionary *)attributeDict context:(NSManagedObjectContext *)context;
- (void)deepCopyEntities:(NSArray *)entities fromContext:(NSManagedObjectContext *)sourceContext toContext:(NSManagedObjectContext *)targetContext;

@end
