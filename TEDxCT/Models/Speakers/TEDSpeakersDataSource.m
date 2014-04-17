//
//  TEDSpeakersDataSource.m
//  TEDxCT
//
//  Created by Daniel Galasko on 4/17/14.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import "TEDSpeakersDataSource.h"

NSString *const kSpeakersCellReuseIdentifier = @"speakersCell";

@implementation TEDSpeakersDataSource

- (void)registerCellsForTableView:(UITableView *)tableView {

}

#pragma mark - UITableViewDataSource -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//}

@end
