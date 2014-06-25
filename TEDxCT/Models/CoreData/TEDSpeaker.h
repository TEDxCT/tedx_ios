//
//  TEDSpeaker.h
//  TEDxCT
//
//  Created by Daniel Galasko on 5/19/14.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TEDEvent, TEDTalk;

@interface TEDSpeaker : NSManagedObject

@property (nonatomic, retain) NSString * descriptionHTML;
@property (nonatomic, retain) NSString * fullName;
@property (nonatomic, retain) NSString * funkyTitle;
@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSNumber * isActive;
@property (nonatomic, retain) TEDTalk *talk;
@property (nonatomic, retain) TEDEvent *event;
@property (nonatomic, retain) NSData *contactDetailsBlob;

@end
