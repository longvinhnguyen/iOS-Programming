//
//  SFAppDelegate.m
//  CardGame
//
//  Created by Long Vinh Nguyen on 4/7/13.
//  Copyright (c) 2013 Home Inc. All rights reserved.
//

#import "SFAppDelegate.h"

#import "SFViewController.h"

@implementation SFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[SFViewController alloc] initWithNibName:@"SFViewController" bundle:nil];
    
    NSMutableArray *days = [NSMutableArray array];
    
    NSDate *date1 = [NSDate dateWithTimeIntervalSinceNow:10000];
    NSDate *date2 = [NSDate dateWithTimeIntervalSinceNow:1000];
    NSDate *date3 = [NSDate dateWithTimeIntervalSinceNow:900];
    NSDate *date4 = [NSDate dateWithTimeIntervalSinceNow:9000];
    
    [days addObject:date1];
    [days addObject:date2];
    [days addObject:date3];
    [days addObject:date4];
    
    NSLog(@"Before sort: %@",days);
    
    [days sortUsingComparator:^(NSDate *obj1, NSDate *obj2){
        return [obj1 compare:obj2];
    }];
    NSLog(@"After sort: %@",days);
    
    
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
