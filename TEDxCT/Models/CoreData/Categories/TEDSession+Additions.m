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
    self.identifier = [NSNumber numberWithInteger:[sessionJSON[@"id"]intValue]];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    NSString *end = sessionJSON[@"endTime"];
    NSString *start = sessionJSON[@"startTime"];
    
    self.endTime = [df dateFromString:end];
    self.startTime = [df dateFromString:start];
    
    NSString *sessionName = sessionJSON[@"name"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    
    NSString *sessionStartTime =[formatter stringFromDate:self.startTime];
    self.name = [NSString stringWithFormat:@"%@ %@", sessionStartTime, sessionName];
}

@end
