//
//  TEDCoreDataTestsHelper.m
//  TEDxCT
//
//  Created by Daniel Galasko on 4/24/14.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import "TEDCoreDataTestsHelper.h"

@implementation TEDCoreDataTestsHelper

+ (NSPersistentStoreCoordinator *)createPersistentStoreCoordinator {
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TEDxCT" withExtension:@"momd"];
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    [coordinator addPersistentStoreWithType:NSInMemoryStoreType
                              configuration:nil
                                        URL:nil
                                    options:nil
                                      error:nil];
    
    return coordinator;
}

+ (NSManagedObjectContext *)createUIContextWithStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator {
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [context setPersistentStoreCoordinator:coordinator];
    return context;
}

+ (NSManagedObjectContext *)createUIContext {
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [context setPersistentStoreCoordinator:[self createPersistentStoreCoordinator]];
    return context;
}
@end
