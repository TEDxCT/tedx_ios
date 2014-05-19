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
    self.descriptionHTML = speakerJSON[@"descriptionHTML"];
    self.funkyTitle = speakerJSON[@"funkyTitle"];
    self.imageURL = speakerJSON[@"imageURL"];
    
    //TODO: FIX isActive
//    self.isActive = speakerJSON[@"isActive"];
}

@end
