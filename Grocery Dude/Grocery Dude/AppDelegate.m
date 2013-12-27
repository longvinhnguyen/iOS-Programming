//
//  AppDelegate.m
//  Grocery Dude
//
//  Created by Long Vinh Nguyen on 12/9/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import <Dropbox/Dropbox.h>
#import "AppDelegate.h"
#import "Item.h"
#import "Unit.h"
#import "LocationAtHome.h"
#import "LocationAtShop.h"

#define APP_KEY     @"jbpjlrsvpqgd7gp"
#define APP_SECRET  @"mrs1jjaupdw4v44"

@implementation AppDelegate

#define debug 1
- (CoreDataHelper *)cdh
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (!_coreDataHelper) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _coreDataHelper = [CoreDataHelper new];
        });
        [_coreDataHelper setupCoreData];
    }
    
    return _coreDataHelper;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    DBAccountManager *accountMgr = [[DBAccountManager alloc] initWithAppKey:APP_KEY secret:APP_SECRET];
    [DBAccountManager setSharedManager:accountMgr];
    DBAccount *account = accountMgr.linkedAccount;
    if (account) {
        DBFilesystem *filesystem = [[DBFilesystem alloc] initWithAccount:account];
        [DBFilesystem setSharedFilesystem:filesystem];
    }
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [[self cdh] backgroundSaveContext];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    DBAccount *account = [[DBAccountManager sharedManager] handleOpenURL:url];
    if (account) {
        DBFilesystem *filesystem = [[DBFilesystem alloc] initWithAccount:account];
        [DBFilesystem setSharedFilesystem:filesystem];
        NSLog(@"Linked to Dropbox!");
        return YES;
    }
    
    return NO;
}

- (void)demo
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'",self.class, NSStringFromSelector(_cmd));
    }
    
    //
}

- (void)showUnitAndItemCount
{
    // List how many items there are in the database
    NSFetchRequest *items = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
    NSError *itemError = nil;
    NSArray *fetchedItems = [[self cdh].context executeFetchRequest:items error:&itemError];
    if (!fetchedItems) {
        NSLog(@"%@", itemError);
    } else {
        NSLog(@"Found %lu item(s)", (unsigned long)fetchedItems.count);
    }
    
    // List how many units there are in the database
    NSFetchRequest *units = [NSFetchRequest fetchRequestWithEntityName:@"Unit"];
    NSError *unitError = nil;
    NSArray *fetchedUnits = [[self cdh].context executeFetchRequest:units error:&unitError];
    if (!fetchedUnits) {
        NSLog(@"%@", itemError);
    } else {
        NSLog(@"Found %lu unit(s)", (unsigned long)fetchedUnits.count);
    }
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [self cdh];
    [self demo];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [[self cdh] backgroundSaveContext];
}

@end
