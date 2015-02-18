//
//  PORoundsViewController.m
//  The Pomodoro
//
//  Created by Jordan Nelson on 2/16/15.
//  Copyright (c) 2015 DevMountain. All rights reserved.
//

#import "PORoundsViewController.h"
#import "POTimer.h"
#import "POTimerViewController.h"

static NSString *reuseID = @"reuseID";

@interface PORoundsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) NSInteger currentRound;
@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@end

@implementation PORoundsViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self registerForNotifications];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Rounds";
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseID];
    
    [self.view addSubview:self.tableView];
}

#pragma mark - registerForNotifications
-(void) registerForNotifications {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(roundCompleteNotification) name:@"roundCompleteNotification"  object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateDetailLabel) name:@"secondTickNotification" object:nil];
}

#pragma mark - tableViewDataSource methods

-(NSArray *) roundTimes {
    return @[@25, @1, @25, @5, @25, @5, @25, @15];
}

-(NSArray *) roundImages {
    return @[[UIImage imageNamed:@"1"],[UIImage imageNamed:@"2"],[UIImage imageNamed:@"1"],[UIImage imageNamed:@"2"],[UIImage imageNamed:@"1"],[UIImage imageNamed:@"2"],[UIImage imageNamed:@"1"],[UIImage imageNamed:@"3"]];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell  = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseID];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ minutes", [self roundTimes][indexPath.row]];
    cell.imageView.image = [self roundImages][indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.currentRound = indexPath.row;
    [self roundSelected];
    
    self.selectedIndexPath = indexPath;
    [self updateDetailLabel];
    
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.detailTextLabel.text = @"";
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self roundTimes].count;
}

#pragma mark - roundSelected
-(void) roundSelected {
    [[POTimer sharedInstance]cancelTimer];
    // Update the minutes and seconds on the [POTimer sharedInstance] from the currentRound property
    [POTimer sharedInstance].minutes = [[self roundTimes][self.currentRound]integerValue];
    [POTimer sharedInstance].seconds = 0;
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"currentRoundNotification" object:nil];
}


-(void)updateDetailLabel {
    NSInteger minutes = [POTimer sharedInstance].minutes;
    NSInteger seconds = [POTimer sharedInstance].seconds;
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath: self.selectedIndexPath];
    
    if ([POTimer sharedInstance].minutes == 0 && [POTimer sharedInstance].seconds == 0) {
         cell.detailTextLabel.text = nil;
    } else {
        cell.detailTextLabel.text =[POTimerViewController timerStringWithMinutes:minutes andSeconds:seconds];
    }

}

-(void)roundCompleteNotification {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Round is complete" message:@"Select an option:" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Next round" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    [self respondToRoundComplete];}]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - respondToRoundComplete
// Response to "Next Round" selection of alertcontoller
-(void)respondToRoundComplete {
    NSInteger row = self.selectedIndexPath.row;
    row ++;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    self.selectedIndexPath = indexPath;
    [self updateDetailLabel];
    
    if (self.currentRound < [self roundTimes].count - 1)
    {
        self.currentRound++;
        
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentRound inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        [self roundSelected];
    }
}

+ (void)roundsLocalNotification {
    NSInteger minutes = [POTimer sharedInstance].minutes;
    NSInteger seconds = [POTimer sharedInstance].seconds;
    
    
    NSDate *fireTime = [[NSDate date]dateByAddingTimeInterval:(minutes * 60)+seconds];
    
    UILocalNotification *localNotification = [UILocalNotification new];
    if(localNotification){
        localNotification.soundName = @"bell_tree.mp3";
        localNotification.fireDate = fireTime;
        localNotification.alertBody = @"Round complete!";
        localNotification.applicationIconBadgeNumber = -1;
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        [[UIApplication sharedApplication] scheduleLocalNotification: localNotification];
    }
}



-(void)viewDidAppear:(BOOL)animated {
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
