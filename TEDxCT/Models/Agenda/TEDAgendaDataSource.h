//
//  TEDAgendaDataSource.h
//  TEDxCT
//
//  Created by Daniel Galasko on 4/2/14.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TEDTalk;

@interface TEDAgendaDataSource : NSObject<UITableViewDataSource>
- (void)registerCellsForTableView:(UITableView *)tableView;
- (void)reloadData;

- (TEDTalk *)talkForItemAtIndexPath:(NSIndexPath *)indexPath;
@end
