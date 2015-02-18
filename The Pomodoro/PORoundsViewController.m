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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(respondToRoundComplete:) name:@"roundCompleteNotification"  object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateDetailLabel) name:@"secondTickNotification" object:nil];
    
}



-(void)respondToRoundComplete: (NSNotification *)notification {
    if (self.currentRound < [self roundTimes].count - 1)
    {
        self.currentRound++;
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentRound inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        [self roundSelected];
    }
}

#pragma mark - tableViewDataSource methods

-(NSArray *) roundTimes {
    return @[@25, @5, @25, @5, @25, @5, @25, @15];
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

-(void)viewDidAppear:(BOOL)animated {
   
}

-(void)updateDetailLabel {
    NSInteger minutes = [POTimer sharedInstance].minutes;
    NSInteger seconds = [POTimer sharedInstance].seconds;
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath: self.selectedIndexPath];
    
    cell.detailTextLabel.text =[POTimerViewController timerStringWithMinutes:minutes andSeconds:seconds];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
