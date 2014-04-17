//
//  TEDSession.h
//  TEDxCT
//
//  Created by Carla G on 2014/04/17.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TEDEvent;

@interface TEDSession : NSManagedObject

@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) TEDEvent *event;

@end
