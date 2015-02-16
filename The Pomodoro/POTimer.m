//
//  POTimer.m
//  The Pomodoro
//
//  Created by Jordan Nelson on 2/16/15.
//  Copyright (c) 2015 DevMountain. All rights reserved.
//

#import "POTimer.h"


@implementation POTimer

+ (POTimer *)sharedInstance {
    static POTimer *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[POTimer alloc] init];
        
    });
    return sharedInstance;
}

#pragma mark - startTimer
-(void)startTimer{
    self.isOn = YES;
    [self isActive];
}

#pragma mark - cancelTimer
-(void)cancelTimer{
    self.isOn = NO;
    
    // Cancel Perform Requests
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

#pragma mark - endTimer
-(void)endTimer {
    self.isOn = NO;
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"roundCompleteNotification" object:nil];
}

#pragma mark - decreaseSecond
-(void)decreaseSecond {
    // decreaseSecond should decrease one second from the remaining time
    if (self.seconds > 0){
        self.seconds --;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"secondTickNotification" object:nil];
    } else if (self.seconds == 0 && self.minutes > 0) {
        self.minutes --;
        self.seconds = 59;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"secondTickNotification" object:nil];
    } else {
        [self endTimer];
    }
}

#pragma mark - isActive 
-(BOOL)isActive{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    if(self.isOn == YES){
        [self decreaseSecond];
        
        // Call itself - performSelector (delayed response)
        [self performSelector:@selector(isActive) withObject:nil afterDelay:1.0];
    }
    
    return self.isOn;
}


@end
