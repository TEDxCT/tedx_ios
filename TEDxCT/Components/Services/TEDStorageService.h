//
//  TEDStorageService.h
//  TEDxCT
//
//  Created by Daniel Galasko on 5/19/14.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TEDStorageService : NSObject
+ (NSString *)pathForImageWithURL:(NSString *)imageURL eventName:(NSString *)eventName createIfNeeded:(BOOL)createIfNeeded;
+ (BOOL)removeResourcesForEventWithName:(NSString *)name;
@end
