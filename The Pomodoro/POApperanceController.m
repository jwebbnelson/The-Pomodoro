//
//  POApperanceController.m
//  The Pomodoro
//
//  Created by Jordan Nelson on 2/17/15.
//  Copyright (c) 2015 DevMountain. All rights reserved.
//

#import "POApperanceController.h"

@implementation POApperanceController


+(void) initializeAppearanceDefaults{
    [[UINavigationBar appearance]setBarTintColor:[UIColor lightGrayColor]];
    [[UINavigationBar appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                          NSFontAttributeName: [UIFont fontWithName:@"Helvetica Bold" size:20.0f]}];
    [[UITabBar appearance]setTintColor:[UIColor orangeColor]];
    [[UITabBar appearance]setBarTintColor:[UIColor lightGrayColor]];
}


@end
