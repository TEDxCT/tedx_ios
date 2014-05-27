//
//  TEDSession.h
//  TEDxCT
//
//  Created by Daniel Galasko on 4/24/14.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TEDEvent, TEDTalk;

@interface TEDSession : NSManagedObject

@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) TEDEvent *event;
@property (nonatomic, retain) NSSet *talks;
@end

@interface TEDSession (CoreDataGeneratedAccessors)

- (void)addTalksObject:(TEDTalk *)value;
- (void)removeTalksObject:(TEDTalk *)value;
- (void)addTalks:(NSSet *)values;
- (void)removeTalks:(NSSet *)values;

@end
