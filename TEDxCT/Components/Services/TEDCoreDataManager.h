//
//  TEDCoreDataManager.h
//  TEDxCT
//
//  Created by Daniel Galasko on 4/2/14.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TEDCoreDataManager : NSObject

+ (TEDCoreDataManager *)sharedManager;
+ (void)initialiseSharedManager;

- (NSManagedObjectContext *)uiContext;

@end
