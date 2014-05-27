//
//  TEDStorageService.h
//  TEDxCT
//
//  Created by Daniel Galasko on 5/19/14.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TEDStorageService : NSObject
+ (BOOL)createDirectoryForEventWithName:(NSString *)name;
+ (NSURL *)resourcesDirectoryFilePathForEventWithName:(NSString *)eventName;
+ (BOOL)removeDirectoryForEventWithName:(NSString *)name;
@end
