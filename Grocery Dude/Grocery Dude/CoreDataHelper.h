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

@property (nonatomic, readonly) NSManagedObjectContext *parentContext;
@property (nonatomic, readonly) NSManagedObjectContext *context;
@property (nonatomic, readonly) NSManagedObjectModel *model;
@property (nonatomic, readonly) NSPersistentStoreCoordinator *coordinator;
@property (nonatomic, readonly) NSPersistentStore *store;
@property (nonatomic, strong) MigrationVC *migrationVC;
@property (nonatomic, strong) UIAlertView *importAlertView;
@property (nonatomic, strong) NSXMLParser *parser;
@property (nonatomic, readonly) NSManagedObjectContext *importContext;
@property (nonatomic, strong) NSTimer *importTimer;

@property (nonatomic, readonly) NSManagedObjectContext *sourceContext;
@property (nonatomic, readonly) NSPersistentStoreCoordinator *sourceCoordinator;
@property (nonatomic, readonly) NSPersistentStore *sourceStore;
@property (nonatomic, readonly) NSPersistentStore *iCloudStore;
- (NSURL *)applicationStoresDirectory;
- (BOOL)reloadStore;


- (void)setupCoreData;
- (void)saveContext;
- (void)backgroundSaveContext;
- (BOOL)iCloudAccountIsSingedIn;
- (void)ensureApproriateStoreIsLoaded;

@end
