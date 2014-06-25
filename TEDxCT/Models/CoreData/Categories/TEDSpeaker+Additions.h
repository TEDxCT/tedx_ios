//
//  TEDSpeaker+Additions.h
//  TEDxCT
//
//  Created by Carla G on 2014/05/12.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import "TEDSpeaker.h"

@interface TEDSpeaker (Additions)

- (void)populateSpeakerWithDictionary:(NSDictionary *)speakerJSON;

- (NSArray *)contactDetails;

@end
