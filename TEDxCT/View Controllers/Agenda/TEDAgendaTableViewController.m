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

@interface TEDAgendaTableViewController ()
@property (nonatomic,strong) TEDAgendaDataSource *agendaDataSource;
@end

@implementation TEDAgendaTableViewController

- (void)loadView {
    self.view = [[UIView alloc] init];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth ];
    [self.view addSubview:self.tableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.agendaDataSource = [[TEDAgendaDataSource alloc] init];
    [self.tableView setDataSource:_agendaDataSource];
    [self.tableView setDelegate:self];
    [self.tableView reloadData];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TEDTalkViewController *newVC = [[TEDTalkViewController alloc] init];
    [self.tabBarController.navigationController pushViewController:newVC animated:YES];
}

@end
