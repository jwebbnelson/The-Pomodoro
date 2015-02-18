//
//  POAppDelegate.m
//  The Pomodoro
//
//  Created by Joshua Howland on 6/3/14.
//  Copyright (c) 2014 DevMountain. All rights reserved.
//

#import "POAppDelegate.h"
#import "PORoundsViewController.h"
#import "POTimerViewController.h"
#import "POApperanceController.h"

@implementation POAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    // Send User confirmation localNotifications upon launching
    UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (locationNotification) {
        // Set icon badge number to zero
        application.applicationIconBadgeNumber = 0;
    }
    
    PORoundsViewController *roundsViewController = [PORoundsViewController new];
    UINavigationController *roundsNC = [[UINavigationController alloc]initWithRootViewController:roundsViewController];
    roundsNC.tabBarItem.title = @"Rounds";
    roundsNC.tabBarItem.image = [UIImage imageNamed:@"flag"];
    
    
    POTimerViewController *timerViewController = [POTimerViewController new];
    timerViewController.tabBarItem.title = @"Timer";
    timerViewController.tabBarItem.image = [UIImage imageNamed:@"timer"];
    
    UITabBarController *tabBarController  = [UITabBarController new];
    tabBarController.viewControllers = @[roundsNC,timerViewController];
   // tabBarController.tabBar.barTintColor = [UIColor blueColor];
    
    self.window.rootViewController = tabBarController;
    
    [POApperanceController initializeAppearanceDefaults];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark - didReceivelocalNotifications
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [[[UIAlertView alloc] initWithTitle:@"You were notified" message:notification.alertBody delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
    application.applicationIconBadgeNumber = 0;
}

#pragma mark - didBecomeActive
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:
         //iOS 8
         [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil]];
        [application registerForRemoteNotifications];
    } else {
        //iOS 7-
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationType)
         (UIRemoteNotificationTypeBadge |
          UIRemoteNotificationTypeSound |
          UIRemoteNotificationTypeAlert)];
    }
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


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
