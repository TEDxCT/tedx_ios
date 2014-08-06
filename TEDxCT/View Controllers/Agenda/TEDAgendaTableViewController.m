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
#import "TEDSession.h"

@interface TEDAgendaTableViewController ()<UISearchDisplayDelegate , UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *agendaTableView;
@property (nonatomic,strong) TEDAgendaDataSource *agendaDataSource;
@property (strong,nonatomic) UISearchBar *searchBar;
@property (strong,nonatomic) UISearchDisplayController *searchController;
@property (strong,nonatomic) NSDateFormatter *dateFormatter;
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
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    _searchBar = searchBar;
    searchBar.placeholder = @"Search Agenda";
    [searchBar sizeToFit];
    self.tableView.tableHeaderView = searchBar;
    
    UISearchDisplayController *searchController = [[UISearchDisplayController alloc]initWithSearchBar:searchBar
                                                                                   contentsController:self];
    searchController.delegate = self;
    searchController.searchResultsDataSource = self.agendaDataSource;
    searchController.searchResultsDelegate = self;
    _searchController = searchController;

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
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectedBackgroundView.backgroundColor =  [UIColor colorWithRed:230/255.f green:55/255.f blue:33/255.f alpha:0.9];
    TEDTalk *selectedTalk = [self.agendaDataSource talkForItemAtIndexPath:indexPath];
    TEDTalkViewController *newVC = [[TEDTalkViewController alloc] initWithTalk:selectedTalk];
    [self.navigationController pushViewController:newVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]init];
    UILabel *sessionLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 0, 0)];
    TEDSession *session = [self.agendaDataSource sessionForSection:section];
    UILabel *sessionName = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, 0, 0)];

    NSInteger lunchIndex = [self.agendaDataSource indexForSessionWithName:@"Lunch"];
    NSInteger afterPartyIndex = [self.agendaDataSource indexForSessionWithName:@"After Party"];
    
    UIColor *textColor = [UIColor colorWithRed:230/255.f green:43/255.f blue:30/255.f alpha:1];
    UIColor *backgroundColor = self.tableView.backgroundColor;//[UIColor colorWithRed:230/255.f green:230/255.f blue:230/255.f alpha:0.9];
    NSDateFormatter *tf;
    if (!_dateFormatter) {
        tf = [[NSDateFormatter alloc] init];
        [tf setDateFormat:@"HH:mm"];
        tf.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
        _dateFormatter = tf;
    }
    tf = self.dateFormatter;
    
    if(section == lunchIndex){
        sessionLabel.text = [NSString stringWithFormat:@"%@ Break", [tf stringFromDate:session.startTime]];
    }
    else if(section == afterPartyIndex){
        sessionLabel.text = [NSString stringWithFormat:@"%@ Close", [tf stringFromDate:session.startTime]];
    }
    else if(section<lunchIndex){
        sessionLabel.text = [NSString stringWithFormat:@"%@ Session %ld", [tf stringFromDate:session.startTime], (long)section + 1];
    }
    else{
        sessionLabel.text = [NSString stringWithFormat:@"%@ Session %ld", [tf stringFromDate:session.startTime], (long)section];
    }
    sessionLabel.textColor = textColor;//[UIColor whiteColor];
    sessionName.text = session.name;
    sessionName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    sessionName.textColor = textColor;//[UIColor whiteColor];
    [sessionLabel sizeToFit];
    [sessionName sizeToFit];
    sessionLabel.backgroundColor = backgroundColor;
    sessionName.backgroundColor = backgroundColor;
    view.backgroundColor = backgroundColor;//textColor;//[UIColor colorWithRed:222/255.f green:222/255.f blue:222/255.f alpha:0.9];
    [view addSubview:sessionLabel];
    [view addSubview:sessionName];
    return view;
    
}

#pragma mark - Searching -
- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView {
    [self.agendaDataSource registerCellsForTableView:tableView];
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView {
    [self.agendaDataSource resetFilter];
    [self.agendaTableView reloadData];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    if (searchString.length > 0) {
        [self.agendaDataSource filterTalksWithSearchString:searchString];
        return YES;
    }
    return NO;
}

#pragma mark - Notification Handlers - 
- (void)handleContentImporterCompleteNotification:(NSNotification *)notification {
    [self.agendaDataSource reloadData];
    [self.agendaTableView reloadData];
}


@end
