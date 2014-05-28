//
//  TEDEvent+Additions.m
//  TEDxCT
//
//  Created by Carla G on 2014/05/28.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import "TEDEvent+Additions.h"

@implementation TEDEvent (Additions)

- (void)populateEventWithDictionary:(NSDictionary *)eventJSON {
    self.identifier = [NSNumber numberWithInteger:[eventJSON[@"id"]intValue]];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    NSString *end = eventJSON[@"endTime"];
    NSString *start = eventJSON[@"startTime"];
    
    self.endDate = [df dateFromString:end];
    self.startDate = [df dateFromString:start];
    self.name = eventJSON[@"name"];
    self.descriptionHTML  = eventJSON[@"descriptionHTML"];
    self.imageURL = eventJSON[@"imageURL"];
    self.locationDescriptionHTML = eventJSON[@"locationDescriptionHTML"];
    self.websiteURL = eventJSON[@"websiteURL"];

}

@end
