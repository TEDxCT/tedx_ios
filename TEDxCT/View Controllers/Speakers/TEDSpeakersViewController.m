//
//  TEDSpeakersViewController.m
//  TEDxCT
//
//  Created by Carla G on 2014/04/14.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import "TEDSpeakersViewController.h"
#import "TEDSpeakersDataSource.h"
#import "TEDSpeakerProfileViewController.h"
#import "TEDSpeaker.h"

@interface TEDSpeakersViewController ()
@property (weak, nonatomic) IBOutlet UITableView *speakersTableView;
@property (strong, nonatomic) TEDSpeakersDataSource *speakersDataSource;
@end

@implementation TEDSpeakersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.speakersDataSource = [[TEDSpeakersDataSource alloc] init];
    [self.speakersDataSource registerCellsForTableView:self.speakersTableView];
    self.speakersTableView.contentOffset = CGPointMake(0, CGRectGetHeight(self.tabBarController.tabBar.frame));
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.speakersDataSource reloadData];
    self.speakersTableView.dataSource = self.speakersDataSource;
    self.speakersTableView.delegate = self;
    self.tabBarController.title = @"All Speakers";
    [self.speakersTableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated {
    self.speakersTableView.dataSource = nil;
    self.speakersTableView.delegate = nil;
    [super viewDidDisappear:animated];
}

#pragma mark - UITableViewDelegate -
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TEDSpeaker *selectedSpeaker = [self.speakersDataSource speakerForItemAtIndexPath:indexPath];
    TEDSpeakerProfileViewController *pvc = [[TEDSpeakerProfileViewController alloc] initWithSpeaker:selectedSpeaker];
    [self.navigationController pushViewController:pvc animated:YES];
}

@end
