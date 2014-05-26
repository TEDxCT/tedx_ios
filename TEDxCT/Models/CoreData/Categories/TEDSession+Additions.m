//
//  TEDSession+Additions.m
//  TEDxCT
//
//  Created by Carla G on 2014/05/26.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import "TEDSession+Additions.h"

@implementation TEDSession (Additions)

- (void)populateSessionWithDictionary:(NSDictionary *)talkJSON {
    self.name = talkJSON[@"name"];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd hh:mm:ss a"];
    
    self.endTime = [df dateFromString:talkJSON[@"endTime"]];
    self.startTime = [df dateFromString:talkJSON[@"startTime"]];
//    self.event = talkJSON[@"events"];
//    self.talks = talkJSON[@"talks"];
}

@end
