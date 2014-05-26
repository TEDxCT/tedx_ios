//
//  TEDTalk+Additions.m
//  TEDxCT
//
//  Created by Carla G on 2014/05/19.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import "TEDTalk+Additions.h"

@implementation TEDTalk (Additions)

- (void)populateTalkWithDictionary:(NSDictionary *)talkJSON {
    self.descriptionHTML = talkJSON[@"descriptionHTML"];
    self.name = talkJSON[@"name"];
    self.imageURL = talkJSON[@"imageURL"];
    self.genre = talkJSON[@"genre"];
    self.orderInSession = talkJSON[@"orderInSession"];
    self.videoURL = talkJSON[@"videoURL"];
    self.session = talkJSON[@"session"];

//    self.speaker = talkJSON[@"speaker"];
}

@end
