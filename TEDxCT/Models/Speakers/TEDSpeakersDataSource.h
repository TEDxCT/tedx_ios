//
//  TEDSpeakersDataSource.h
//  TEDxCT
//
//  Created by Daniel Galasko on 4/17/14.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TEDSpeaker;

@interface TEDSpeakersDataSource : NSObject<UITableViewDataSource>
- (void)registerCellsForTableView:(UITableView *)tableView;
- (void)reloadData;

- (TEDSpeaker *)speakerForItemAtIndexPath:(NSIndexPath *)indexPath;
@end
