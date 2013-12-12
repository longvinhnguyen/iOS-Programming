//
//  AppDelegate.m
//  Grocery Dude
//
//  Created by Long Vinh Nguyen on 12/9/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "Item.h"
#import "Unit.h"
#import "LocationAtHome.h"
#import "LocationAtShop.h"

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
    [[self cdh] saveContext];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
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
    [[self cdh] saveContext];
}

@end
