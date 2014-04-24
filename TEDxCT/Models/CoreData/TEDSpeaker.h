//
//  TEDSpeaker.h
//  TEDxCT
//
//  Created by Daniel Galasko on 4/24/14.
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
@property (nonatomic) BOOL isActive;
@property (nonatomic, retain) TEDTalk *talk;

@end
