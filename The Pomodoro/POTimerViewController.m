//
//  POTimerViewController.m
//  The Pomodoro
//
//  Created by Jordan Nelson on 2/16/15.
//  Copyright (c) 2015 DevMountain. All rights reserved.
//

#import "POTimerViewController.h"

@interface POTimerViewController ()
@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) IBOutlet UILabel *roundLabel;

@end

@implementation POTimerViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self registerForNotifications];
    }
    return self;
}

- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(respondToSecondTick) name:@"secondTickNotification" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(respondToCurrentRound) name:@"currentRoundNotification" object:nil];
}

- (void) respondToSecondTick {
    [self updateTimerLabel];
    
}

-(void) respondToCurrentRound {
    [self updateTimerLabel];
    self.startButton.enabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startRound:(id)sender {
    
}

-(void)updateTimerLabel {
    
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
