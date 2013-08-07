//
//  AppDelegate.m
//  TestScrollViewPhoto
//
//  Created by VisiKard MacBook Pro on 5/31/13.
//  Copyright (c) 2013 VisiKard MacBook Pro. All rights reserved.
//

#import "AppDelegate.h"
#import "BackOfKardMultiPhotoNavigationViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    NSArray *photos = [NSArray arrayWithObjects:@"http://www.chrissycostanza.com/wp-content/uploads/2013/01/Chrissy-Costanza-On-Camera.jpg",
                       @"http://images6.fanpop.com/image/photos/32900000/Cloud-trolls-Seph-final-fantasy-vii-32918761-500-366.jpg",
                       @"http://ps2media.ign.com/ps2/image/article/724/724990/dirge-of-cerberus-final-fantasy-vii-20060811065031259-000.jpg",
                       @"http://fc09.deviantart.net/fs15/f/2007/015/4/0/Chamba__s_Illidan_Stormrage_by_pulyx.jpg",
                       @"http://fc08.deviantart.net/fs18/f/2007/161/e/3/Black_Temple_by_shangha1.jpg",
                       @"http://images3.wikia.nocookie.net/__cb20121119181547/finalfantasy/images/f/fc/FFVIIbattleexample.jpg",
                       @"http://images2.fanpop.com/image/photos/12400000/Tiffany-tiffany-alvord-12419279-501-752.jpg",nil];
    
    
    BackOfKardMultiPhotoNavigationViewController *photoViewController = [[BackOfKardMultiPhotoNavigationViewController alloc] initWithPhotoUrls:photos withIndex:0 andHeight:255];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:photoViewController];
//    self.viewController = [[BackOfKardMultiPhotoNavigationViewController alloc] initWithPhotoUrls:photos withIndex:0 andHeight:255];
    self.viewController = nav;
    
    [GMSServices provideAPIKey:GOOGLE_MAP_API_KEY];
    
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
