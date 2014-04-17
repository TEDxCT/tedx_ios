//
//  TEDSpeakersDataSource.m
//  TEDxCT
//
//  Created by Daniel Galasko on 4/17/14.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import "TEDSpeakersDataSource.h"
#import "TEDSpeakersTableViewCell.h"

NSString *const kSpeakersCellReuseIdentifier = @"speakersCell";

@implementation TEDSpeakersDataSource

- (void)registerCellsForTableView:(UITableView *)tableView {
    [tableView registerNib:[UINib nibWithNibName:@"TEDSpeakersTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kSpeakersCellReuseIdentifier];
}

#pragma mark - UITableViewDataSource -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TEDSpeakersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSpeakersCellReuseIdentifier];
    [cell.speakerNameLabel setText:@"Bruce Willis"];
    return cell;
}

@end
