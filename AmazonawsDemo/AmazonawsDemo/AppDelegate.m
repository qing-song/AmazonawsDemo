//
//  AppDelegate.m
//  AmazonawsDemo
//
//  Created by qingsong on 2020/4/11.
//  Copyright © 2020 qingsong. All rights reserved.
//

#import "AppDelegate.h"

#import "MessageViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    
    MessageViewController *rootViewController = [[MessageViewController alloc] init];
    self.window.rootViewController = rootViewController;
    
    return YES;
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    //只支持竖屏
    return UIInterfaceOrientationMaskPortrait;
}

@end
