//
//  TEDTalk.h
//  TEDxCT
//
//  Created by Carla G on 2014/04/17.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TEDSession, TEDSpeaker;

@interface TEDTalk : NSManagedObject

@property (nonatomic, retain) NSString * descriptionHTML;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * orderInSession;
@property (nonatomic, retain) NSString * videoURL;
@property (nonatomic, retain) TEDSession *session;
@property (nonatomic, retain) TEDSpeaker *speaker;

@end
