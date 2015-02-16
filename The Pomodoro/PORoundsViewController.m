//
//  PORoundsViewController.m
//  The Pomodoro
//
//  Created by Jordan Nelson on 2/16/15.
//  Copyright (c) 2015 DevMountain. All rights reserved.
//

#import "PORoundsViewController.h"

static NSString *reuseID = @"reuseID";

@interface PORoundsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) NSInteger currentRound;
@property (nonatomic, strong) UITableView * tableView;


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

    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseID];
    
    [self.view addSubview:self.tableView];
    
    
}

#pragma mark - registerForNotifications
-(void) registerForNotifications {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(respondToRoundComplete:) name:@"RoundCompleteNotification"  object:nil];
}



-(void)respondToRoundComplete: (NSNotification *)notification {
    if (self.currentRound < [self roundTimes].count -1) {
        self.currentRound++;
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentRound inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        [self roundSelected];
        
    }
    
}


-(NSArray *) roundTimes {
    return @[@25, @5, @25, @5, @25, @5, @25, @15];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ minutes", [self roundTimes][indexPath.row]];
    
    return cell;
    
}

-(void) roundSelected {
//    that will update the minutes and seconds on the [POTimer sharedInstance] from the currentRound property
    [[NSNotificationCenter defaultCenter]postNotificationName:@"currentRoundNotification" object:nil];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.currentRound = indexPath;
    [self roundSelected];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self roundTimes].count;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
