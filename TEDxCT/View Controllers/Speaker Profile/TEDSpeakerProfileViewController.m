//
//  TEDSpeakerProfileViewController.m
//  TEDxCT
//
//  Created by Carla G on 2014/04/14.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import "TEDSpeakerProfileViewController.h"

#import "TEDSpeaker.h"
#import "TEDSpeakerProfileDataSource.h"

@interface TEDSpeakerProfileViewController ()
@property (strong,nonatomic,readonly) TEDSpeaker *speaker;

@property (strong,nonatomic) TEDSpeakerProfileDataSource *profileDataSource;
@end

@implementation TEDSpeakerProfileViewController

- (instancetype)initWithSpeaker:(TEDSpeaker *)speaker {
    if (self = [super init]) {
        _speaker = speaker;
        _profileDataSource = [[TEDSpeakerProfileDataSource alloc] initWithSpeaker:speaker];
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.profileDataSource registerReusableCellsForTableView:self.tableView];
    self.tableView.dataSource = self.profileDataSource;
    self.tableView.allowsSelection = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.profileDataSource reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.profileDataSource heightForRowAtIndexPath:indexPath inTableView:tableView];
}

@end
