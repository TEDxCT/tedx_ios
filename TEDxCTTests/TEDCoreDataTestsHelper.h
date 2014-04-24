//
//  TEDCoreDataTestsHelper.h
//  TEDxCT
//
//  Created by Daniel Galasko on 4/24/14.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TEDCoreDataTestsHelper : NSObject

+ (NSPersistentStoreCoordinator *)createPersistentStoreCoordinator;
+ (NSManagedObjectContext *)createUIContextWithStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator;

+ (NSManagedObjectContext *)createUIContext;
@end
