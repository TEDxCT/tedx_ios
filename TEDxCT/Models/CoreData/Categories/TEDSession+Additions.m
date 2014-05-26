//
//  TEDSession+Additions.m
//  TEDxCT
//
//  Created by Carla G on 2014/05/26.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import "TEDSession+Additions.h"

@implementation TEDSession (Additions)

- (void)populateSessionWithDictionary:(NSDictionary *)sessionJSON {
    self.name = sessionJSON[@"name"];
    
    //TODO: fix
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd hh:mm:ss a"];
    
    self.endTime = [df dateFromString:sessionJSON[@"endTime"]];
    self.startTime = [df dateFromString:sessionJSON[@"startTime"]];
}

@end
