//
//  TEDSpeaker.h
//  TEDxCT
//
//  Created by Carla G on 2014/04/17.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TEDSpeaker : NSManagedObject

@property (nonatomic, retain) NSNumber * isActive;
@property (nonatomic, retain) NSString * fullName;
@property (nonatomic, retain) NSString * descriptionHTML;
@property (nonatomic, retain) NSString * imageURL;

@end
