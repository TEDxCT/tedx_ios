//
//  TEDEvent.h
//  TEDxCT
//
//  Created by Carla G on 2014/07/14.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TEDSession, TEDSpeaker;

@interface TEDEvent : NSManagedObject

@property (nonatomic, retain) NSString * descriptionHTML;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSNumber * isTrashed;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSString * locationDescriptionHTML;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSString * websiteURL;
@property (nonatomic, retain) NSSet *sessions;
@property (nonatomic, retain) TEDSpeaker *speakers;
@end

@interface TEDEvent (CoreDataGeneratedAccessors)

- (void)addSessionsObject:(TEDSession *)value;
- (void)removeSessionsObject:(TEDSession *)value;
- (void)addSessions:(NSSet *)values;
- (void)removeSessions:(NSSet *)values;

@end
