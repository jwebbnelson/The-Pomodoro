//
//  POTimer.h
//  The Pomodoro
//
//  Created by Jordan Nelson on 2/16/15.
//  Copyright (c) 2015 DevMountain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface POTimer : NSObject

@property (nonatomic,assign) NSInteger minutes;
@property (nonatomic,assign) NSInteger seconds;

@property (nonatomic,assign) BOOL isOn;

+ (POTimer *)sharedInstance;

-(void)startTimer;
-(void)cancelTimer;

@end
