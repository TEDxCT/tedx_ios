//
//  TEDAppDelegate.h
//  TEDxCT
//
//  Created by Carla G on 2014/03/31.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TEDAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
