//
//  TEDApplicationConfiguration.m
//  TEDxCT
//
//  Created by Carla G on 2014/05/12.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import "TEDApplicationConfiguration.h"

@implementation TEDApplicationConfiguration

- (NSURL *)eventJSONURL {
    return [NSURL URLWithString:@"http://95.85.26.105/tedx_server/response/event.php/"];
}

- (NSURL *)sponsorsJSONURL {
    return [NSURL URLWithString:@"http://95.85.26.105/tedx_server/response/sponsors.php/"];
}

- (NSString *)eventName {
    //Case sensitive
    return @"Alex's house";
}

@end
