//
//  CoreDataHelper.h
//  Grocery Dude
//
//  Created by Long Vinh Nguyen on 12/9/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MigrationVC.h"

@interface CoreDataHelper : NSObject<UIAlertViewDelegate, NSXMLParserDelegate>

@property (nonatomic, readonly) NSManagedObjectContext *context;
@property (nonatomic, readonly) NSManagedObjectModel *model;
@property (nonatomic, readonly) NSPersistentStoreCoordinator *coordinator;
@property (nonatomic, readonly) NSPersistentStore *store;
@property (nonatomic, strong) MigrationVC *migrationVC;
@property (nonatomic, strong) UIAlertView *importAlertView;
@property (nonatomic, strong) NSXMLParser *parser;
@property (nonatomic, readonly) NSManagedObjectContext *importContext;

- (void)setupCoreData;
- (void)saveContext;

@end
