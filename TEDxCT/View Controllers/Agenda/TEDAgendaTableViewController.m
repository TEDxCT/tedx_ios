//
//  TEDAgendaTableViewController.m
//  TEDxCT
//
//  Created by Carla G on 2014/04/02.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import "TEDAgendaTableViewController.h"

#import "TEDAgendaDataSource.h"
#import "TEDTalkViewController.h"
#import "TEDTalkTableViewCell.h"

@interface TEDAgendaTableViewController ()
@property (nonatomic,strong) TEDAgendaDataSource *agendaDataSource;
@end

@implementation TEDAgendaTableViewController

- (void)loadView {
    self.view = [[UIView alloc] init];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth ];
    [self.view addSubview:self.tableView];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.title = @"Agenda";
    [self.agendaDataSource reloadData];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.agendaDataSource = [[TEDAgendaDataSource alloc] init];
    [self.agendaDataSource registerCellsForTableView:self.tableView];
    [self.tableView setDataSource:self.agendaDataSource];
    [self.tableView setDelegate:self];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate -


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TEDTalk *selectedTalk = [self.agendaDataSource talkForItemAtIndexPath:indexPath];
    TEDTalkViewController *newVC = [[TEDTalkViewController alloc] initWithTalk:selectedTalk];
    [self.tabBarController.navigationController pushViewController:newVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

/*
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]init];
    UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, CGRectGetWidth(self.tableView.frame), 44)];
    headerLabel.text = @"Session 1";
    
    headerView.backgroundColor = [UIColor colorWithRed:200/255.f green:200/255.f blue:200/255.f alpha:0.8];
    
    [headerView addSubview:headerLabel];
    return headerView;
}*/

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

@end
