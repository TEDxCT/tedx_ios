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

@interface TEDSpeakersViewController ()
@property (weak, nonatomic) IBOutlet UITableView *speakersTableView;
@property (strong, nonatomic) TEDSpeakersDataSource *dataSource;
@end

@implementation TEDSpeakersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [[TEDSpeakersDataSource alloc] init];
    [self.dataSource registerCellsForTableView:self.speakersTableView];
    self.speakersTableView.contentOffset = CGPointMake(0, CGRectGetHeight(self.tabBarController.tabBar.frame));
    self.speakersTableView.dataSource = self.dataSource;
    self.speakersTableView.delegate = self;
}

#pragma mark - UITableViewDelegate -
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TEDSpeakerProfileViewController *pvc = [[TEDSpeakerProfileViewController alloc] init];
    [self.navigationController pushViewController:pvc animated:YES];
}

@end
