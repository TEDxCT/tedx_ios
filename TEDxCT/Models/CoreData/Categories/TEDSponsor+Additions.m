//
//  TEDSponsor+Additions.m
//  TEDxCT
//
//  Created by Carla G on 2014/06/25.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import "TEDSponsor+Additions.h"

@implementation TEDSponsor (Additions)

- (void)populateSponsorWithDictionary:(NSDictionary *)sponsorJSON {
    self.identifier = [NSNumber numberWithInt:[sponsorJSON[@"id"] intValue]];
    if (![sponsorJSON[@"descriptionHTML"] isKindOfClass:[NSNull class]]){
        self.descriptionHTML = sponsorJSON[@"descriptionHTML"];
    } else {
        self.descriptionHTML = @"No description available";
    }
    self.imageURL = sponsorJSON[@"imageURL"];
    self.name = sponsorJSON[@"name"];
}

@end
