//
//  POTimerViewController.h
//  The Pomodoro
//
//  Created by Jordan Nelson on 2/16/15.
//  Copyright (c) 2015 DevMountain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface POTimerViewController : UIViewController

+ (NSString *)timerStringWithMinutes:(NSInteger)minutes andSeconds:(NSInteger)seconds;

@end
