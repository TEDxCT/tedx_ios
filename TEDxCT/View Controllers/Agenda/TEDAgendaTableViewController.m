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
@property (weak, nonatomic) IBOutlet UITableView *agendaTableView;
@property (nonatomic,strong) TEDAgendaDataSource *agendaDataSource;
@end

@implementation TEDAgendaTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.title = @"Agenda";
    
    [self.agendaTableView setDataSource:self.agendaDataSource];
    [self.agendaTableView setDelegate:self];
    [self.agendaDataSource reloadData];
    [self.agendaTableView reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleContentImporterCompleteNotification:) name:kContentImporterCompleteNotification object:nil];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.agendaDataSource = [[TEDAgendaDataSource alloc] init];
    [self.agendaDataSource registerCellsForTableView:self.agendaTableView];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidDisappear:(BOOL)animated {
    self.agendaTableView.dataSource = nil;
    self.agendaTableView.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kContentImporterCompleteNotification object:nil];
    [super viewDidDisappear:animated];
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
    return 80;
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

#pragma mark - Notification Handlers - 
- (void)handleContentImporterCompleteNotification:(NSNotification *)notification {
    [self.agendaDataSource reloadData];
    [self.agendaTableView reloadData];
}

@end
