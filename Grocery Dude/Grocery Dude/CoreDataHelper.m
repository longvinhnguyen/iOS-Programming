//
//  CoreDataHelper.m
//  Grocery Dude
//
//  Created by Long Vinh Nguyen on 12/9/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "CoreDataHelper.h"
#import "CoreDataImporter.h"
#import "Faulter.h"

@implementation CoreDataHelper

#define debug 1

#pragma mark - FILES
NSString *storeFileName =  @"Grocery-Dude.sqlite";
NSString *sourceStoreFileName = @"DefaultData.sqlite";
NSString *iCloudStoreFileName = @"iCloud.sqlite";

#pragma mark - PATHS
- (NSString *)applicationDocumentsDirectory {
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }

    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (NSURL *)applicationStoresDirectory {
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    NSURL *storesDirectory = [[NSURL fileURLWithPath:[self applicationDocumentsDirectory]] URLByAppendingPathComponent:@"Stores"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[storesDirectory path]]) {
        NSError *error = nil;
        if ([fileManager createDirectoryAtURL:storesDirectory withIntermediateDirectories:YES attributes:nil error:&error]) {
            if (debug == 1) {
                NSLog(@"Successfully created Stores directory");
            } else {
                NSLog(@"Failed to create Stores directory %@", error);
            }
        }
    }
    
    return storesDirectory;
}

- (NSURL *)storeURL {
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return [[self applicationStoresDirectory] URLByAppendingPathComponent:storeFileName];
}

- (NSURL *)sourceStoreURL
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:[sourceStoreFileName stringByDeletingPathExtension] ofType:[sourceStoreFileName pathExtension]]];
}

- (NSURL *)iCloudStoreURL
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return [[self applicationStoresDirectory] URLByAppendingPathComponent:iCloudStoreFileName];
}




#pragma mark - SETUP
- (id)init
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    if (self = [super init]) {
        _model = [NSManagedObjectModel mergedModelFromBundles:nil];
        _coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
        _parentContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_parentContext performBlockAndWait:^{
            [_parentContext setPersistentStoreCoordinator:_coordinator];
            [_parentContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
        }];
        _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _context.parentContext = _parentContext;
        [_context setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
        _importContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_importContext performBlockAndWait:^{
            [_importContext setUndoManager:nil];
            [_importContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
        }];
        _importContext.parentContext = _context;
        
        
        _sourceCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
        _sourceContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_sourceContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
        [_sourceContext performBlockAndWait:^{
            [_sourceContext setUndoManager:nil];
        }];
        _sourceContext.parentContext = _context;
        
        _seedCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
        _seedContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_seedContext performBlockAndWait:^{
            [_seedContext setPersistentStoreCoordinator:_seedCoordinator];
            [_seedContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
            [_seedContext setUndoManager:nil];
        }];
        _seedInProgress = NO;
        [self listentForStoreChanges];
    }
    return self;
}

- (void)loadStore
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (_store) {
        return;
    }
    
    BOOL userMigrationManager = NO;
    if (userMigrationManager && [self isMigrationNecessaryForStore:[self storeURL]]) {
        [self performBackgroundManagedMigrationForStore:[self storeURL]];
    } else {
        
        NSError *error = nil;
        NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption:@YES,
                                  NSInferMappingModelAutomaticallyOption:@YES,
//                                  NSSQLitePragmasOption: @{@"journal_mode": @"DELETE"}
                                  };
        _store = [_coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[self storeURL] options:options error:&error];
        
        if (!_store) {
            NSLog(@"Failed to add store. Error: %@", error);
            abort();
        } else {
            if (debug == 1) {
                NSLog(@"Successfully added store: %@", _store);
            }
        }
    }
}

- (void)loadSourceStore
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (_sourceStore) {
        return;
    }
    
    NSDictionary *options = @{NSReadOnlyPersistentStoreOption: @(YES)};
    NSError *error = nil;
//    _sourceStore = [_sourceCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[self sourceStoreURL] options:options error:&error];
    if (!_sourceStore) {
        NSLog(@"Failed to add source store. Error: %@", error);
        abort();
    } else {
        NSLog(@"Successfully added source store: %@", _sourceStore);
    }
}

- (BOOL)loadiCloudStore
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (_iCloudStore) {
        return NO;
    }
    
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption: @(YES),
                              NSInferMappingModelAutomaticallyOption: @(YES),
                              NSPersistentStoreUbiquitousContentNameKey:@"Grocery-Dude"
//                              ,NSPersistentStoreUbiquitousContentURLKey:@"ChangeLogs"
                              };
    
    NSError *error;
    _iCloudStore = [_coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:Nil URL:[self iCloudStoreURL] options:options error:&error];
    if (_iCloudStore) {
        NSLog(@"** The iCloud Store has been successfully configured at '%@' **", _iCloudStore.URL.path);
        [self confirmMergeWithiCloud];
//        [self destroyAlliCloudDataForThisApplication];
        return YES;
    }
    NSLog(@"FAILED to configure the iCloud Store: %@ **", error);
    return NO;
}

- (void)setupCoreData
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (!_store && !_iCloudStore) {
        if ([self iCloudEnabledByUser]) {
            NSLog(@"** Attempting to load the iCloud Store **");
            if ([self loadiCloudStore]) return;
        }
        
        NSLog(@"** Attempting to load the Local, Non-iCloud Store **");
        [self setDefaultDataStoreAsInitialStore];
        [self loadStore];
    } else {
        NSLog(@"SKIPPED setupCoreData, there's an existing Store:\n ** _store(%@)\n **_iCloudStore(%@)", _store, _iCloudStore);
    }
//    [self importGroceryDudeTestData];
//    [self checkIfDefaultDataNeedsImporting];
//    [self loadSourceStore];
//    [_sourceContext performBlock:^{
//        NSLog(@"*** Attempting to migrate '%@' into '%@' .. Please wait ***", sourceStoreFileName, storeFileName);
//        NSError *error = nil;
//        if (![_sourceCoordinator migratePersistentStore:_sourceStore toURL:[self storeURL] options:nil withType:NSSQLiteStoreType error:&error]) {
//            NSLog(@"FAILED to migrate: %@", error);
//        } else {
//            NSLog(@"The source store '%@' has been migrated to the target store '%@'", sourceStoreFileName, storeFileName);
//            [_context performBlock:^{
//                [self somehthingChanged];
//            }];
//        }
//    }];
    
}


#pragma mark - SAVING
- (void)saveContext
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if ([_context hasChanges]) {
        NSError *error = nil;
        if ([_context save:&error]) {
            NSLog(@"_context SAVED changes to persistent store");
        } else {
            NSLog(@"Failed to save context %@", _context);
            [self showValidationError:error];
        }
    } else {
        NSLog(@"SKIPPED _context save, there is no changes");
    }
}

#pragma mark - MIGRATION MANAGER
- (BOOL)isMigrationNecessaryForStore:(NSURL *)storeUrl
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self storeURL].path]) {
        if (debug == 1) {
            NSLog(@"SKIPPED MIGRATION: Source data missing.");
        }
        return NO;
    }
    
    NSError *error = nil;
    NSDictionary *sourceMetadata = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:NSSQLiteStoreType URL:[self storeURL] error:&error];
    NSManagedObjectModel *destinationModel = _coordinator.managedObjectModel;
    if ([destinationModel isConfiguration:nil compatibleWithStoreMetadata:sourceMetadata]) {
        if (debug == 1) {
            NSLog(@"SKIPPED MIGRATION: Source is already compatible.");
            return NO;
        }
    }
    return YES;
}

- (BOOL)migrateStore:(NSURL *)sourceStore
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    BOOL success = NO;
    NSError *error = nil;
    
    // STEP 1 - Gather the source, destination and mapping model
    NSDictionary *sourceMetadata  = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:NSSQLiteStoreType URL:[self storeURL] error:&error];
    NSManagedObjectModel *sourceModel = [NSManagedObjectModel mergedModelFromBundles:nil forStoreMetadata:sourceMetadata];
    
    NSManagedObjectModel *destinationModel = _model;
    
    NSMappingModel *mappingModel = [NSMappingModel mappingModelFromBundles:nil forSourceModel:sourceModel destinationModel:destinationModel];
    
    // STEP 2 - Perform migration, assuming the mapping model isn't null
    if (mappingModel) {
        NSError *error = nil;
        NSMigrationManager *migrationManager = [[NSMigrationManager alloc] initWithSourceModel:sourceModel destinationModel:destinationModel];
        [migrationManager addObserver:self forKeyPath:@"migrationProgress" options:NSKeyValueObservingOptionNew context:NULL];
        
        NSURL *destinStore = [[self applicationStoresDirectory] URLByAppendingPathComponent:@"Temp.sqlite"];
        success = [migrationManager migrateStoreFromURL:sourceStore type:NSSQLiteStoreType options:nil withMappingModel:mappingModel toDestinationURL:destinStore destinationType:NSSQLiteStoreType destinationOptions:nil error:&error];
        
        if (success) {
            // STEP 3 - Replace the old store with new migrated store
            if ([self replaceStore:sourceStore withStore:destinStore]) {
                if (debug == 1) {
                    NSLog(@"SUCCESSFULLY MIGRATED %@ to the Current Model", sourceStore.path);
                    [migrationManager removeObserver:self forKeyPath:@"migrationProgress"];
                }
            }
        } else {
            if (debug == 1) {
                NSLog(@"FAILED MIGRATION: %@",error);
            }
        }
    } else {
         NSLog(@"FAILED MIGRATION: Mapping model is null");
    }
    
    return YES;
}

- (BOOL)replaceStore:(NSURL *)old withStore:(NSURL *)new
{
    BOOL success = NO;
    NSError *error = nil;
    if ([[NSFileManager defaultManager] removeItemAtURL:old error:&error]) {
        error = nil;
        if ([[NSFileManager defaultManager] moveItemAtURL:new toURL:old error:&error]) {
            success = YES;
        } else {
            if (debug == 1) {
                NSLog(@"FAILED to re-home new store %@", error);
            }
        }
    } else {
        NSLog(@"FAILED to remove old store %@: Error:%@",old, error);
    }
    
    return success;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"migrationProgress"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            float progress = [[change objectForKey:NSKeyValueChangeNewKey] floatValue];
            self.migrationVC.progressView.progress = progress;
            int percentage = progress * 100;
            NSString *string = [NSString stringWithFormat:@"Migration Progress: %i%%", percentage];
            NSLog(@"%@",string);
            self.migrationVC.label.text = string;
        });
    }
}

- (void)performBackgroundManagedMigrationForStore:(NSURL *)storeURL
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    // show migration progress view prevent user from using the app
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.migrationVC = [sb instantiateViewControllerWithIdentifier:@"migration"];
    UIApplication *sa = [UIApplication sharedApplication];
    UINavigationController *nc = (UINavigationController *)sa.keyWindow.rootViewController;
    [nc presentViewController:self.migrationVC animated:NO completion:nil];
    
    // perform migration in background, so it doesn't freeze the UI
    // This way progress can be shown to the user
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        BOOL done = [self migrateStore:[self storeURL]];
        if (done) {
            // When migration finishes add newly migrated store
            NSError *error = nil;
            _store = [_coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[self storeURL] options:nil error:&error];
            
            if (!_store) {
                NSLog(@"Failed to add a migrated store error: %@", error);
                abort();
            } else {
                NSLog(@"Sucessfully added a migrated store: %@", _store);
                [self.migrationVC dismissViewControllerAnimated:YES completion:nil];
                self.migrationVC = nil;
            }
            
        }
        
    });
}

#pragma mark - VALIDATION ERROR HANDLING
- (void)showValidationError:(NSError *)anError
{
    if (anError && [anError.domain isEqualToString:@"NSCocoaErrorDomain"]) {
        NSArray *errors = nil;
        NSString *text = @"";
        
        // Populate array with errors
        if (anError.code == NSValidationMultipleErrorsError) {
            errors = anError.userInfo[NSDetailedErrorsKey];
        } else {
            errors = [NSArray arrayWithObject:anError];
        }
        
        // Display the error(s)
        if (errors && errors.count > 0) {
            // Build error message text based on errors
            for (NSError *error in errors) {
                NSString *entity = [[error.userInfo[@"NSValidationErrorObject"] entity] name];
                NSString *property = error.userInfo[@"NSValidationErrorKey"];
                
                switch (error.code) {
                    case NSValidationRelationshipDeniedDeleteError:
                        text = [text stringByAppendingFormat:@"%@ delete was denied because there are associated %@\n(Error code %li)\n\n", entity, property, (long)error.code];
                        break;
                    case NSValidationRelationshipLacksMinimumCountError:
                        text = [text stringByAppendingFormat: @" the '%@' relationship count is too small (Code %li)." , property, (long) error.code];
                        break;
                    case NSValidationRelationshipExceedsMaximumCountError:
                        text = [text stringByAppendingFormat: @" the '%@' relationship count is too large (Code %li)." , property, (long) error.code];
                        break;
                    case NSValidationMissingMandatoryPropertyError:
                        text = [text stringByAppendingFormat: @" the '%@' property is missing (Code %li).", property, (long) error.code];
                        break;
                    case NSValidationNumberTooSmallError:
                        text = [text stringByAppendingFormat: @" the '%@' number is too small (Code %li).", property, (long) error.code];
                        break;
                    case NSValidationNumberTooLargeError:
                        text = [text stringByAppendingFormat:@" the '%@' number is too large (Code %li).", property, (long) error.code];
                        break;
                    case NSValidationDateTooSoonError:
                        text = [text stringByAppendingFormat: @" the '%@' date is too soon (Code %li).", property, (long) error.code];
                        break;
                    case NSValidationDateTooLateError:
                        text = [text stringByAppendingFormat: @" the '%@' date is too late (Code %li).", property, (long) error.code];
                        break;
                    case NSValidationInvalidDateError:
                        text = [text stringByAppendingFormat: @" the '%@' date is invalid (Code %li).", property, (long) error.code];
                        break;
                    case NSValidationStringTooLongError:
                        text = [text stringByAppendingFormat: @" the '%@' text is too long (Code %li).", property, (long) error.code];
                        break;
                    case NSValidationStringTooShortError:
                        text = [text stringByAppendingFormat: @" the '%@' text is too short (Code %li).", property, (long) error.code];
                        break;
                    case NSValidationStringPatternMatchingError:
                        text = [text stringByAppendingFormat: @" the '%@' text doesn't match the specified pattern (Code %li)." , property, (long) error.code];
                        break;
                    case NSManagedObjectValidationError:
                        text = [text stringByAppendingFormat:@" generated validation error (Code %li)", (long) error.code];
                        break;
                    default:
                        text = [text stringByAppendingFormat:@"Unhandled error code %li in showValidationError method", (long)error.code];
                        break;
                }
            }
            
            // display error message
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Validation Error" message:[NSString stringWithFormat:@"%@Please double-tap the home button and close this application by swipping the application screenshot upwards", text] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
            [alertView show];
        }
    }
}

#pragma mark - DATA IMPORT
- (BOOL)isDefaultDataAlreadyImportedForStoreWithURL:(NSURL *)url ofType:(NSString *)type
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    NSError *error;
    NSDictionary *dictionary = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:type URL:url error:&error];
    if (error) {
        NSLog(@"Error reading persistent store metadata %@", error.localizedDescription);
    } else {
        NSNumber *defaultDataAlreadyImported = [dictionary valueForKey:@"DefaultDataImported"];
        if (![defaultDataAlreadyImported boolValue]) {
            NSLog(@"Default DATA has NOT already been imported");
            return NO;
        }
    }
    
    if (debug == 1) {
        NSLog(@"Default DATA HAS already been imported");
    }
    
    return YES;
}

- (void)checkIfDefaultDataNeedsImporting
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (![self isDefaultDataAlreadyImportedForStoreWithURL:[self storeURL] ofType:NSSQLiteStoreType]) {
        self.importAlertView = [[UIAlertView alloc] initWithTitle:@"Import Default Data?" message:@"If you've never used Grocery Dude before then some default data might help you understand how to use it. Tap 'import' to import default data. Tap 'Cancel' to skip the import, especially if you've done this before on other devices" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Import", nil];
        [self.importAlertView show];
    }
}

- (void)importFromXML:(NSURL *)url
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    self.parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    self.parser.delegate = self;
    
    NSLog(@"**** START PARSE OF %@", url.path);
    [self.parser parse];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SomethingChanged" object:nil];
    NSLog(@"**** END PARSE OF %@", url.path);
    
}

- (void)setDefaultDataAsImportedForDate:(NSPersistentStore *)aStore
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    // get metadata dictionary
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:[[aStore metadata] copy]];
    
    if (debug == 1) {
        NSLog(@"__Store Metadata BEFORE changes__ \n %@", dictionary);
    }
    
    // edit metadata dictionary
    [dictionary setObject:@(YES) forKey:@"DefaultDataImported"];
    
    // set metadata dictionary
    [self.coordinator setMetadata:dictionary forPersistentStore:aStore];
    
    if (debug == 1) {
        NSLog(@"__Store Metadata AFTER changes__ \n %@", dictionary);
    }
}

#pragma mark - DELEGATE: UIAlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == self.importAlertView) {
        if (buttonIndex == 1) {
            NSLog(@"Default Data Import Approved by User");
            [_importContext performBlock:^{
                // XML import
                [self importFromXML:[[NSBundle mainBundle] URLForResource:@"DefaultData" withExtension:@"xml"]];

                // Deep Copy Import From persistent store
//                [self loadSourceStore];
//                [self deepCopyFromPersistentStore:[self sourceStoreURL]];
            }];
        } else {
            NSLog(@"Default Data Import Cancelled by User");
        }
        
        [self setDefaultDataAsImportedForDate:_store];
    } else if (alertView == self.seedAlertView) {
        if (buttonIndex == alertView.firstOtherButtonIndex) {
            [self mergeNoniCloudDataWithiCloud];
        }
    }
}

#pragma mark - UNIQUE ATTRIBUTE SELECTION 
- (NSDictionary *)selectedUniqueAttributes
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    NSMutableArray *entities = [NSMutableArray new];
    NSMutableArray *attributes = [NSMutableArray new];
    
    // Select an attribute in each entity for uniqueness
    [entities addObject:@"Item"];
    [entities addObject:@"Unit"];
    [entities addObject:@"LocationAtHome"];
    [entities addObject:@"LocationAtShop"];
    [entities addObject:@"Item_Photo"];
    [attributes addObject:@"name"];
    [attributes addObject:@"name"];
    [attributes addObject:@"storedIn"];
    [attributes addObject:@"aisle"];
    [attributes addObject:@"data"];
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:attributes forKeys:entities];
    
    return dictionary;
}

#pragma mark - DELEGATE: NSXMLParser
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    if (debug == 1) {
        NSLog(@"Parse Error %@", parseError.localizedDescription);
    }
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    [self.importContext performBlockAndWait:^{
        // STEP 1: Process only the 'item' element in the XML file
        if ([elementName isEqualToString:@"item"]) {
            
            // STEP 2: Prepare CoreDataImporter
            CoreDataImporter *importer = [[CoreDataImporter alloc] initWithUniqueAttributes:[self selectedUniqueAttributes]];
            
            // STEP 3a: Insert a unique 'Item' object
            NSManagedObject *item = [importer insertBasicObjectInTargetEntity:@"Item" targetEntityAttribute:@"name" sourceXMLAttribute:@"name" attributeDict:attributeDict context:_importContext];
            
            // STEP 3b: Insert a unique 'Unit' object
            NSManagedObject *unit = [importer insertBasicObjectInTargetEntity:@"Unit" targetEntityAttribute:@"name" sourceXMLAttribute:@"unit" attributeDict:attributeDict context:_importContext];

            // STEP 3c: Insert a unique 'LocationAtHome' object
            NSManagedObject *locationAtHome = [importer insertBasicObjectInTargetEntity:@"LocationAtHome" targetEntityAttribute:@"storedIn" sourceXMLAttribute:@"locationathome" attributeDict:attributeDict context:_importContext];
            
            // STEP 3d: Insert a unique 'LocationAtShop' object
            NSManagedObject *locationAtShop = [importer insertBasicObjectInTargetEntity:@"LocationAtShop" targetEntityAttribute:@"aisle" sourceXMLAttribute:@"locationatshop" attributeDict:attributeDict context:_importContext];
            
            // STEP 4: Manually add extra attribute values
            [item setValue:@NO forKey:@"listed"];
            
            // STEP 5: Create relationships
            [item setValue:unit forKey:@"unit"];
            [item setValue:locationAtHome forKey:@"locationAtHome"];
            [item setValue:locationAtShop forKey:@"locationAtShop"];
            
            // STEP 6: Save new objects to persistent store
            [CoreDataImporter saveContext:_importContext];
            
            // STEP 7: Turn objects into faults to save memory
            [Faulter faultObjectWithID:locationAtHome.objectID inContext:_importContext];
            [Faulter faultObjectWithID:locationAtShop.objectID inContext:_importContext];
            [Faulter faultObjectWithID:unit.objectID inContext:_importContext];
            [Faulter faultObjectWithID:item.objectID inContext:_importContext];
        }
    }];
}

- (void)setDefaultDataStoreAsInitialStore
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[self storeURL].path]) {
        NSURL *defaultDataURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"DefaultData" ofType:@"sqlite"]];
        NSError *error;
        if (![fileManager copyItemAtURL:defaultDataURL toURL:[self storeURL] error:&error]) {
            NSLog(@"DefaultData.sqlite copy FAIL: %@", error.localizedDescription);
        } else {
            NSLog(@"A copy of DefaultData.sqlite was set as as the initial store for %@", [self storeURL].path);
        }
    }
}

- (void)deepCopyFromPersistentStore:(NSURL *)url
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@' %@", self.class, NSStringFromSelector(_cmd), url.path);
    }
    
    _importTimer = [NSTimer scheduledTimerWithTimeInterval: 2.0 target:self selector:@ selector(somethingChanged) userInfo:nil repeats:YES];
    
    [_sourceContext performBlock:^{
        NSLog(@"*** STARTED DEEP COPY FROM DEFAULT DATA PERSISTENT STORE ***");
        NSArray *entitiesToCopy = [NSArray arrayWithObjects:@"LocationAtHome", @"LocationAtShop", @"Unit", @"Item", nil];
        CoreDataImporter *importer = [[CoreDataImporter alloc] initWithUniqueAttributes:[self selectedUniqueAttributes]];
        [importer deepCopyEntities:entitiesToCopy fromContext:_sourceContext toContext:_importContext];
        [_context performBlock:^{
            // Tell the interface to refresh once import completes
            [_importTimer invalidate];
            [self somethingChanged];
            NSLog(@"*** FINISHED DEEP COPY FROM DEFAULT DATA PERSISTENT STORE ***");
        }];
    }];
}

#pragma mark - UNDERLYING DATA CHANGE NOTIFICATION
- (void)somethingChanged
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    // Send a notification that tells observing interfaces to refresh their data
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SomethingChanged" object:nil];
}

#pragma mark - TEST DATA IMPORT (This code is Grocery Dude data specific)
- (void)importGroceryDudeTestData
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    NSNumber *imported = [[NSUserDefaults standardUserDefaults] objectForKey:@"TestDataImport"];
    if (!imported.boolValue) {
        NSLog(@"Importing test data ...");
        [_importContext performBlock:^{
            NSManagedObject *locationAtHome = [NSEntityDescription insertNewObjectForEntityForName:@"LocationAtHome" inManagedObjectContext:_importContext];
            NSManagedObject *locationAtShop = [NSEntityDescription insertNewObjectForEntityForName:@"LocationAtShop" inManagedObjectContext:_importContext];
            [locationAtHome setValue:@"Test Home Location" forKey:@"storedIn"];
            [locationAtShop setValue:@"Test Shop Location" forKey:@"aisle"];
            for (int i = 1; i < 101; i++) {
                @autoreleasepool {
                    NSManagedObject *item = [NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:_importContext];
                    [item setValue:[NSString stringWithFormat:@"Test item %i", i] forKey:@"name"];
                    [item setValue:locationAtHome forKey:@"locationAtHome"];
                    [item setValue:locationAtShop forKey:@"locationAtShop"];
                    
                    // Insert Photo
                    NSManagedObject *photo = [NSEntityDescription insertNewObjectForEntityForName:@"Item_Photo" inManagedObjectContext:_importContext];
                    [photo setValue:UIImagePNGRepresentation([UIImage imageNamed:@"GroceryHead.png"]) forKey:@"data"];
                    [item setValue:photo forKey:@"photo"];
                    NSLog(@"Inserting %@", [item valueForKey:@"name"]);
                    [CoreDataImporter saveContext:_importContext];
                    [Faulter faultObjectWithID:item.objectID inContext:_importContext];
                }
            }
            
            [_importContext reset];
            // force table refresh
            [self somethingChanged];
            
            // ensure import was a one off
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"TestDataImport"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }];
    } else {
        NSLog(@"Skipped test data import");
    }
}

- (void)backgroundSaveContext
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    [self saveContext];
    // Then save the parent context
    [_parentContext performBlock:^{
        if ([_parentContext hasChanges]) {
            NSError *error = nil;
            if ([_parentContext save:&error]) {
                NSLog(@"_parentContext SAVED changes to persistent store");
            } else {
                NSLog(@"_parentContext FAILED to save %@", error);
                [self showValidationError:error];
            }
        } else {
            NSLog(@"_parentContext SKIPPED saving as there are no changes");
        }
    }];
}

#pragma mark - CORE DATA RESET
- (void)resetContext:(NSManagedObjectContext *)moc
{
    [moc performBlockAndWait:^{
        [moc reset];
    }];
}

- (BOOL)reloadStore
{
    BOOL success = NO;
    NSError *error = nil;
    if (![_coordinator removePersistentStore:_store error:&error]) {
        NSLog(@"Unable to remove persistent store : %@", error);
    }
    
    [self resetContext:_sourceContext];
    [self resetContext:_importContext];
    [self resetContext:_context];
    [self resetContext:_parentContext];
    _store = nil;
    [self setupCoreData];
    [self somethingChanged];
    if (_store) {
        success = YES;
    }
    
    return success;
}

#pragma mark - ICLOUD
- (BOOL)iCloudAccountIsSingedIn
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    id token = [[NSFileManager defaultManager] ubiquityIdentityToken];
    if (token) {
        NSLog(@"** iCloud is SIGNED IN with token '%@'", token);
        return YES;
    }
    
    NSLog(@"** iCloud is NOT SIGNED IN");
    NSLog(@"--> Is iCloud Documents and Data enabled for a valid iCloud account on your Mac & iOS Device or iOS Simulator");
    NSLog(@"--> Have you enabled the iCloud Capability in the Application Target?");
    NSLog(@"--> Is there a CODE_SIGN_ENTITLEMENTS Xcode warning that needs fixing? You may need to specifically choose a developer instead of using Automatic selection");
    NSLog(@"--> Are you using a Pre-iOS7 Simulator?");
    return NO;
}

- (void)listentForStoreChanges
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    NSNotificationCenter *dc = [NSNotificationCenter defaultCenter];
    [dc addObserver:self selector:@selector(storesWillChange:) name:NSPersistentStoreCoordinatorStoresWillChangeNotification object:_coordinator];
    [dc addObserver:self selector:@selector(storesDidChange:) name:NSPersistentStoreCoordinatorStoresDidChangeNotification object:_coordinator];
    [dc addObserver:self selector:@selector(persistentStoreDidImportUbiquitiousContentChanges:) name:NSPersistentStoreDidImportUbiquitousContentChangesNotification object:_coordinator];

}

- (void)storesWillChange:(NSNotification *)n
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    [_importContext performBlockAndWait:^{
        [_importContext save:nil];
        [self resetContext:_importContext];
    }];
    
    [_context performBlockAndWait:^{
        [_context save:nil];
        [self resetContext:_context];
    }];
    
    [_parentContext performBlockAndWait:^{
        [_parentContext save:nil];
        [self resetContext:_parentContext];
    }];
    
    // Refresh UI
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SomethingChanged" object:nil userInfo:nil];
}

- (void)storesDidChange:(NSNotification *)n
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    // Refresh UI
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SomethingChanged" object:nil userInfo:nil];
}

- (void)persistentStoreDidImportUbiquitiousContentChanges:(NSNotification *)n
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    [_context performBlockAndWait:^{
        [_context mergeChangesFromContextDidSaveNotification:n];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SomethingChanged" object:nil userInfo:nil];
    }];
}

- (BOOL)iCloudEnabledByUser
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize]; // Ensure current value
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"iCloudEnabled"] boolValue]) {
        NSLog(@"** iCloud is ENABLED in Settings **");
        return YES;
    }
    NSLog(@"** iCloud is DISABLED in Settings");
    return NO;
}

#pragma mark - CORE DATA RESET
- (void)removeAllStoresFromCoordinator:(NSPersistentStoreCoordinator *)psc
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    for (NSPersistentStore *s in psc.persistentStores) {
        NSError *error = nil;
        if (![psc removePersistentStore:s error:&error]) {
            NSLog(@"Error removing persistent store: %@", error);
        }
    }
}

- (void)resetCoreData
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    [_importContext performBlockAndWait:^{
        [_importContext save:nil];
        [self resetContext:_importContext];
    }];
    
    [_context performBlockAndWait:^{
        [_context save:nil];
        [self resetContext:_importContext];
    }];
    
    [_parentContext performBlockAndWait:^{
        [_parentContext save:nil];
        [self resetContext:_parentContext];
    }];
    [self removeAllStoresFromCoordinator:_coordinator];
    _store = nil;
    _iCloudStore = nil;
    
}

- (void)ensureApproriateStoreIsLoaded
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }

    if (!_store && !_iCloudStore) {
        return; // If neither store is loaded, skip (usually first launch)
    }
    
    if (![self iCloudEnabledByUser] && _store) {
        NSLog(@"The Non-iCloud Store is loaded as it should be");
        return;
    }
    
    if ([self iCloudEnabledByUser] && _iCloudStore) {
        NSLog(@"The iCloud Store is loaded as it should be");
        return;
    }
    
    NSLog(@"** The user preference on using iCloud with this application appears to have changed. Core Data will now be reset. **");
    [self resetCoreData];
    [self setupCoreData];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SomethingChanged" object:nil];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Your preference on using iCloud with this application appears to have changed" message:@"Content has been update accordingly" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    [alert show];
    
    
}


- (BOOL)unloadStore:(NSPersistentStore *)ps
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (ps) {
        NSPersistentStoreCoordinator *psc = ps.persistentStoreCoordinator;
        NSError *error = nil;
        if (![psc removePersistentStore:ps error:&error]) {
            NSLog(@"ERROR removing store from the coordinator: %@", error);
            return NO;
        } else {
            ps = nil;
            return YES;
        }
    }
    
    return YES;
}

- (void)removeFileAtURL:(NSURL *)url
{
    NSError *error = nil;
    if (![[NSFileManager defaultManager] removeItemAtURL:url error:&error]) {
        NSLog(@"Failed to delete '%@' from %@", [url lastPathComponent], [url URLByDeletingLastPathComponent]);
    } else {
        NSLog(@"Deleted '%@' from %@", [url lastPathComponent], [url URLByDeletingLastPathComponent]);
    }
}

#pragma mark - ICLOUD SEEDING
- (BOOL)loadNoniCloudStoreAsSeedStore
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (_seedInProgress) {
        NSLog(@"Seed already in progress ...");
        return NO;
    }
    
    if (![self unloadStore:_seedStore]) {
        NSLog(@"Failed to ensure _seedStore was removed prior to migration");
        return NO;
    }
    
    if (![self unloadStore:_store]) {
        NSLog(@"Failed to ensure _store was removed prior to migration");
        return NO;
    }
    
    NSDictionary *options = @{NSReadOnlyPersistentStoreOption: @(YES)};
    NSError *error = nil;
    _seedStore = [_seedCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[self storeURL] options:options error:&error];
    if (!_seedStore) {
        NSLog(@"Failed to load Non-iCloud Store as Seed Store. Error: %@", error);
        return NO;
    }
    NSLog(@"Successfully loaded Non-iCloud Store as Seed Store: %@", _seedStore);
    return YES;
}

- (void)mergeNoniCloudDataWithiCloud
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    _importTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(somethingChanged) userInfo:nil repeats:YES];
    [_seedContext performBlock:^{
        if ([self loadNoniCloudStoreAsSeedStore]) {
            NSLog(@"*** STARTED DEEP COPY FROM NON-ICLOUD STORE TO ICLOUD STORE ***");
            NSArray *entitiesToCopy = @[@"Item", @"Unit", @"LocationAtHome", @"LocationAtShop"];
            CoreDataImporter *importer = [[CoreDataImporter alloc] initWithUniqueAttributes:[self selectedUniqueAttributes]];
            [importer deepCopyEntities:entitiesToCopy fromContext:_seedContext toContext:_importContext];
        }
        
        [_context performBlock:^{
            // Tell the interface to refresh once import completes
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SomethingChanged" object:nil];
        }];
        
        NSLog(@"*** FINISHED DEEP COPY FROM NON-ICLOUD STORE TO ICLOUD STORE");
        NSLog(@"*** REMOVING OLD NON-ICLOUD STORE");
        if ([self unloadStore:_seedStore]) {
            [_context performBlock:^{
                // Tell the interface to refresh once import completes
                [[NSNotificationCenter defaultCenter] postNotificationName:@"SomethingChanged" object:nil];
                
                // Remove migrated store
                NSString *wal = [storeFileName stringByAppendingString:@"-wal"];
                NSString *shm = [storeFileName stringByAppendingString:@"-shm"];
                [self removeFileAtURL:[self storeURL]];
                [self removeFileAtURL:[[self applicationStoresDirectory] URLByAppendingPathComponent:wal]];
                [self removeFileAtURL:[[self applicationStoresDirectory] URLByAppendingPathComponent:shm]];
            }];
        }
        
        [_context performBlock:^{
            // Stop periodically refreshing the interface 
            [_importTimer invalidate];
        }];
    }];
}

- (void)confirmMergeWithiCloud
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[[self storeURL] path]]) {
        NSLog(@"Skipped unnecessary migration of Non-iCloud store to iCloud (there's no store file).");
        return;
    }
    
    _seedAlertView = [[UIAlertView alloc] initWithTitle:@"Merge with iCloud?" message:@"This will move your existing data into iCloud. If you don't merge now, you can merge later by toggling iCloud for this application in Settings" delegate:self cancelButtonTitle:@"Don't Merge" otherButtonTitles:@"Merge", nil];
    [_seedAlertView show];
}

#pragma mark - ICLOUD RESET
- (void)destroyAlliCloudDataForThisApplication
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[[_iCloudStore URL] path]]) {
        NSLog(@"Skipped destroying iCloud content, _iCloudStore.URL is %@", [_iCloudStore URL].path);
        return;
    }
    
    NSLog(@"\n\n\n\n\n**** Destroying ALL iCloud content for this application, this could take a while... ****\n\n\n\n");
    [self removeAllStoresFromCoordinator:_coordinator];
    [self removeAllStoresFromCoordinator:_seedCoordinator];
    _coordinator = nil;
    _seedCoordinator = nil;
    
    NSDictionary *options = @{NSPersistentStoreUbiquitousContentNameKey: @"Grocery-Dude",
//                              NSPersistentStoreUbiquitousContentURLKey: @"ChangeLogs" // Optional since iOS 7
                              };
    NSError *error;
    if ([NSPersistentStoreCoordinator removeUbiquitousContentAndPersistentStoreAtURL:[_iCloudStore URL] options:options error:&error]) {
        NSLog(@"\n\n\n\n\n");
        NSLog(@"*This application's iCloud content has been destroyed*");
        NSLog(@"*On ALL devices, please delete any reference to this application in *");
        NSLog(@"*Settings > iCloud > Storage & Backup > Manage Storage > Show All*");
        NSLog(@"\n\n\n\n\n");
        abort();
        /*
         The application is forced closed to ensure iCloud data is wiped cleanly.
         This method shouldn't be called in a production application.
         */
    } else {
        NSLog(@"\n\n FAILED to destroy iCloud content at URL: %@ Error:%@", [_iCloudStore URL], error);
    }
}

@end
