//
//  NZHAppDelegate.m
//  NZ Herald 2
//
//  Created by Will Townsend on 5/25/14
//  Copyright (c) 2014 WTSNZ. All rights reserved.
//

#import "NZHAppDelegate.h"

#import "DebugLog.h"
#import "NZHIndexViewController.h"

@implementation NZHAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Configure Window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[NZHIndexViewController alloc] init];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
