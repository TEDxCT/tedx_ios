//
//  TEDSession+Additions.h
//  TEDxCT
//
//  Created by Carla G on 2014/05/26.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import "TEDSession.h"

@interface TEDSession (Additions)

- (void)populateSessionWithDictionary:(NSDictionary *)sessionJSON withDateFromatter:(NSDateFormatter *)dateFormatter andTimeFormatter:(NSDateFormatter *)timeFormatter;

@end
