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
    self.identifier = [NSNumber numberWithInt:[talkJSON[@"id"] intValue]];
    self.descriptionHTML = talkJSON[@"descriptionHTML"];
    self.name = talkJSON[@"name"];
    self.imageURL = talkJSON[@"imageURL"];
    self.genre = talkJSON[@"genre"];
    self.orderInSession = talkJSON[@"orderInSession"];
    if(![talkJSON[@"videoURL"] isKindOfClass:[NSNull class]]) {
        self.videoURL = talkJSON[@"videoURL"];
    }
}

@end
