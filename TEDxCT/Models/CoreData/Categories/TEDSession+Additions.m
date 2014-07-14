//
//  TEDSession+Additions.m
//  TEDxCT
//
//  Created by Carla G on 2014/05/26.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import "TEDSession+Additions.h"

@implementation TEDSession (Additions)

- (void)populateSessionWithDictionary:(NSDictionary *)sessionJSON withDateFromatter:(NSDateFormatter *)dateFormatter andTimeFormatter:(NSDateFormatter *)timeFormatter {
    self.identifier = [NSNumber numberWithInteger:[sessionJSON[@"id"]intValue]];
    
    NSNumber *end = sessionJSON[@"endTime"];
    NSNumber *start = sessionJSON[@"startTime"];
    
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:end.unsignedLongLongValue];
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:start.unsignedLongLongValue];
    
    self.endTime = endDate;
    self.startTime = startDate;
        
    self.name = sessionJSON[@"name"];
}

@end
