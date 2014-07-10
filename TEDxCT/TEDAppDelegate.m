//
//  TEDAppDelegate.m
//  TEDxCT
//
//  Created by Carla G on 2014/03/31.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import "TEDAppDelegate.h"
#import "TEDTabBarController.h"
#import "TEDCoreDataManager.h"
#import "TEDContentImporter.h"

@implementation TEDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Override point for customization after application launch.
    [TEDCoreDataManager initialiseSharedManager];
    [TEDContentImporter initialiseSharedImporter];
    [[TEDContentImporter sharedImporter] requestContentImportForAllContent];
    self.tabBarController = [[TEDTabBarController alloc] init];
    [self.window setRootViewController:self.tabBarController];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self.window setTintColor:[UIColor colorWithRed:228/255.0f green:45/255.0f blue:29/255.0f alpha:1.f]];
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
    // Saves changes in the application's managed object context before the application terminates.
}

@end
