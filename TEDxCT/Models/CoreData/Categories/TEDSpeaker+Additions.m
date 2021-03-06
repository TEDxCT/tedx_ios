//
//  TEDSpeaker+Additions.m
//  TEDxCT
//
//  Created by Carla G on 2014/05/12.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import "TEDSpeaker+Additions.h"

@implementation TEDSpeaker (Additions)

- (void)populateSpeakerWithDictionary:(NSDictionary *)speakerJSON {
    self.identifier = [NSNumber numberWithInt:[speakerJSON[@"id"] intValue]];
    if (![speakerJSON[@"descriptionHTML"] isKindOfClass:[NSNull class]]){
        self.descriptionHTML = speakerJSON[@"descriptionHTML"];
    } else {
        self.descriptionHTML = @"No description available";
    }
    self.funkyTitle = speakerJSON[@"funkyTitle"];
    if(![speakerJSON[@"imageURL"] isKindOfClass:[NSNull class]]){
        self.imageURL = speakerJSON[@"imageURL"];
    }
    self.fullName = speakerJSON[@"fullName"];
    self.contactDetailsBlob = [NSKeyedArchiver archivedDataWithRootObject:speakerJSON[@"contactDetails"]];
    
    //TODO: FIX isActive
//    self.isActive = speakerJSON[@"isActive"];
}

- (NSArray *)contactDetails {
    if (self.contactDetailsBlob) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:self.contactDetailsBlob];
    }
    return nil;
}

@end
