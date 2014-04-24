//
//  TEDEvent.h
//  TEDxCT
//
//  Created by Daniel Galasko on 4/24/14.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TEDSession;

@interface TEDEvent : NSManagedObject

@property (nonatomic, retain) NSString * descriptionHTML;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * locationDescriptionHTML;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSString * websiteURL;
@property (nonatomic, retain) NSSet *sessions;
@end

@interface TEDEvent (CoreDataGeneratedAccessors)

- (void)addSessionsObject:(TEDSession *)value;
- (void)removeSessionsObject:(TEDSession *)value;
- (void)addSessions:(NSSet *)values;
- (void)removeSessions:(NSSet *)values;

@end
