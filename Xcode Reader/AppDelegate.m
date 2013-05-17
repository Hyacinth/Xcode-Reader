//
//  AppDelegate.m
//  Xcode Reader
//
//  Created by Song Hui on 05/14/13.
//  Copyright (c) 2013 Code Bone. All rights reserved.
//

#if DEBUG
#import <SparkInspector/SparkInspector.h>
#endif
#import "AppDelegate.h"
#import "SRevealSideController.h"
#import "SToolkitController.h"
#import "SReaderController.h"
#import "SSearchManager.h"
#import "SLibraryManager.h"
#import "SSearchController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Enable the Spark Inspector
    #if DEBUG
    [SparkInspector enableObservation];
    #endif

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    // Test SToolkitController and SRevealSideController
    SReaderController *readerController = [[SReaderController alloc] init];
//    UIViewController *searchController = [[UIViewController alloc] init];
	SSearchController *searchController = [[SSearchController alloc] initWithNibName:nil bundle:nil];
    UIViewController *exploreController = [[UIViewController alloc] init];
    UIViewController *bookmarkController = [[UIViewController alloc] init];
    SToolkitController *toolkitController = [[SToolkitController alloc] initWithViewControllers:@[searchController, exploreController, bookmarkController] selectedIndex:0];
    SRevealSideController *revealSideController = [[SRevealSideController alloc] initWithSideController:toolkitController centralController:readerController];
    searchController.view.backgroundColor = [UIColor colorWithRed:0.86 green:0.86 blue:0.86 alpha:1.0];
    exploreController.view.backgroundColor = [UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:1.0];
    bookmarkController.view.backgroundColor = [UIColor colorWithRed:0.13 green:0.13 blue:0.13 alpha:1.0];
    self.window.rootViewController = revealSideController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

	[[SLibraryManager share] reloadLibraries];
	[[SSearchManager share] prepareSearch];
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
	[[SSearchManager share] prepareSearch];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

}

@end