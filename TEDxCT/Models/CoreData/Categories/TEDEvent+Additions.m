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
    
    NSNumber *end = eventJSON[@"endDate"];
    NSNumber *start = eventJSON[@"startDate"];
    
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:end.unsignedLongLongValue];
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:start.unsignedLongLongValue];
    
    self.endDate = endDate;
    self.startDate = startDate;
    self.name = eventJSON[@"name"];
    self.descriptionHTML  = eventJSON[@"descriptionHTML"];
    if(![eventJSON[@"imageURL"] isKindOfClass:[NSNull class]]) {
        self.imageURL = eventJSON[@"imageURL"];
    }
    self.locationDescriptionHTML = eventJSON[@"locationDescriptionHTML"];
    self.websiteURL = eventJSON[@"websiteURL"];
    self.isTrashed = [NSNumber numberWithBool:NO];
    
    self.latitude = [NSNumber numberWithDouble:[eventJSON[@"latitude"] doubleValue]];
    self.longitude =[NSNumber numberWithDouble:[eventJSON[@"longitude"] doubleValue]];
}

@end
