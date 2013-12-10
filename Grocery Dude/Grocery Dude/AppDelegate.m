//
//  AppDelegate.m
//  Grocery Dude
//
//  Created by Long Vinh Nguyen on 12/9/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "Item.h"

@implementation AppDelegate

#define debug 1
- (CoreDataHelper *)cdh
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (!_coreDataHelper) {
        _coreDataHelper = [CoreDataHelper new];
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
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    [request setSortDescriptors:@[sort]];

    
    NSArray *fetchedObjects = [_coreDataHelper.context executeFetchRequest:request error:nil];
    for (Item *item in fetchedObjects) {
        NSLog(@"Deleting Object = %@", item.name);
        [_coreDataHelper.context deleteObject:item];
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
