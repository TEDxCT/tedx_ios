//
//  TEDSpeaker.h
//  TEDxCT
//
//  Created by Carla G on 2014/05/12.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TEDTalk;

@interface TEDSpeaker : NSManagedObject

@property (nonatomic, retain) NSString * descriptionHTML;
@property (nonatomic, retain) NSString * fullName;
@property (nonatomic, retain) NSString * funkyTitle;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSNumber * isActive;
@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) TEDTalk *talk;

@end
