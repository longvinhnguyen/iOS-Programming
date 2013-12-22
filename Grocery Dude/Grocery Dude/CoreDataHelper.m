//
//  CoreDataHelper.m
//  Grocery Dude
//
//  Created by Long Vinh Nguyen on 12/9/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "CoreDataHelper.h"
#import "CoreDataImporter.h"

@implementation CoreDataHelper

#define debug 1

#pragma mark - FILES
NSString *storeFileName =  @"Grocery-Dude.sqlite";

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


#pragma mark - SETUP
- (id)init
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    if (self = [super init]) {
        _model = [NSManagedObjectModel mergedModelFromBundles:nil];
        _coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
        _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_context setPersistentStoreCoordinator:_coordinator];
        _importContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_importContext performBlockAndWait:^{
            [_importContext setPersistentStoreCoordinator:_coordinator];
            [_importContext setUndoManager:nil];
        }];
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

- (void)setupCoreData
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [self setDefaultDataStoreAsInitialStore];
    [self loadStore];
    [self checkIfDefaultDataNeedsImporting];
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
            }];
        } else {
            NSLog(@"Default Data Import Cancelled by User");
        }
        
        [self setDefaultDataAsImportedForDate:_store];
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
    [attributes addObject:@"name"];
    [attributes addObject:@"name"];
    [attributes addObject:@"storedIn"];
    [attributes addObject:@"aisle"];
    
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
            [_importContext refreshObject:item mergeChanges:NO];
            [_importContext refreshObject:locationAtHome mergeChanges:NO];
            [_importContext refreshObject:locationAtShop mergeChanges:NO];
            [_importContext refreshObject:unit mergeChanges:NO];
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


@end
