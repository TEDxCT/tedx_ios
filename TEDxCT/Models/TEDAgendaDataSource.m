//
//  TEDAgendaDataSource.m
//  TEDxCT
//
//  Created by Daniel Galasko on 4/2/14.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import "TEDAgendaDataSource.h"
#import "TEDTalkTableViewCell.h"

NSString *const kTalkCellReuseIdentifier = @"talkCell";

@implementation TEDAgendaDataSource

- (void)registerCellsForTableView:(UITableView *)tableView {
    [tableView registerNib:[UINib nibWithNibName:@"TEDTalkTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kTalkCellReuseIdentifier];
}

#pragma mark - UITableViewDataSource -
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TEDTalkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTalkCellReuseIdentifier];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}


@end
