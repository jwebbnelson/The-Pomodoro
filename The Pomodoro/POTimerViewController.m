//
//  POTimerViewController.m
//  The Pomodoro
//
//  Created by Jordan Nelson on 2/16/15.
//  Copyright (c) 2015 DevMountain. All rights reserved.
//

#import "POTimerViewController.h"
#import "POTimer.h"
#import "PORoundsViewController.h"

@interface POTimerViewController ()
@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) IBOutlet UILabel *roundLabel;
@property (strong, nonatomic) IBOutlet UIButton *stopButton;

@end

@implementation POTimerViewController

// Instantiate with Nib
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self registerForNotifications];
    }
    return self;
}

#pragma mark - registerForNotifications
- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(respondToSecondTick) name:@"secondTickNotification" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(respondToCurrentRound) name:@"currentRoundNotification" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(respondToCurrentRound) name:@"roundCompleteNotification" object:nil];
}

#pragma mark - unregisterForNotifications
- (void) unregisterForNotifications {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - dealloc
-(void)dealloc {
    [self unregisterForNotifications];
}

// Updates TimerLabel
- (void) respondToSecondTick {
    [self updateTimerLabel];
 
}

#pragma mark - respondToCurrentRound
// New Round
-(void) respondToCurrentRound {
    [self updateTimerLabel];
    self.startButton.enabled = YES;
    self.stopButton.enabled = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - startRound
// Implements startButton action
- (IBAction)startRound:(id)sender {
    self.startButton.enabled = NO;
    self.stopButton.enabled = YES;
    [[POTimer sharedInstance] startTimer];
}
- (IBAction)stopRound:(id)sender {
    self.startButton.enabled = YES;
    self.stopButton.enabled = NO;
    
    [[POTimer sharedInstance]cancelTimer];
}

#pragma mark - updateTimerLabel
-(void)updateTimerLabel {
    NSInteger minutes = [POTimer sharedInstance].minutes;
    NSInteger seconds = [POTimer sharedInstance].seconds;
    
    self.roundLabel.text = [POTimerViewController timerStringWithMinutes:minutes andSeconds:seconds];
}

// Returns Timer String in correct format
+ (NSString *)timerStringWithMinutes:(NSInteger)minutes andSeconds:(NSInteger)seconds
    {
        NSString *timerString;
        if (minutes >= 10)
        {
            timerString = [NSString stringWithFormat:@"%li:", (long)minutes];
        }
        else
        {
            timerString = [NSString stringWithFormat:@"0%li:", (long)minutes];
        }
        if (seconds >= 10)
        {
            timerString = [timerString stringByAppendingString:[NSString stringWithFormat:@"%li", (long)seconds]];
        }
        else
        {
            timerString = [timerString stringByAppendingString:[NSString stringWithFormat:@"0%li", (long)seconds]];
        }
        return timerString;
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
