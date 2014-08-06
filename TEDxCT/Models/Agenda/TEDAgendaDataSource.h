//
//  TEDAgendaDataSource.h
//  TEDxCT
//
//  Created by Daniel Galasko on 4/2/14.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TEDTalk;
@class TEDSession;

@interface TEDAgendaDataSource : NSObject<UITableViewDataSource>
- (void)registerCellsForTableView:(UITableView *)tableView;
- (void)reloadData;

- (TEDTalk *)talkForItemAtIndexPath:(NSIndexPath *)indexPath;
- (TEDSession *)sessionForSection:(NSInteger)section;
- (NSInteger)indexForSessionWithName:(NSString *)sessionName;

- (void)resetFilter;
- (void)filterTalksWithSearchString:(NSString *)searchString;
@end
