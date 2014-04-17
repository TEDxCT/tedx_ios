//
//  TEDAgendaDataSource.h
//  TEDxCT
//
//  Created by Daniel Galasko on 4/2/14.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TEDAgendaDataSource : NSObject<UITableViewDataSource>

- (void)registerCellsForTableView:(UITableView *)tableView;

@end
