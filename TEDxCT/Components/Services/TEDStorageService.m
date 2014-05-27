//
//  TEDStorageService.m
//  TEDxCT
//
//  Created by Daniel Galasko on 5/19/14.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import "TEDStorageService.h"

@implementation TEDStorageService

+ (BOOL)createDirectoryForEventWithName:(NSString *)name {
    NSURL *directoryURL = [self resourcesDirectoryFilePathForEventWithName:name];
    if(![[NSFileManager defaultManager] fileExistsAtPath:[directoryURL path]]) {
        return [[NSFileManager defaultManager] createDirectoryAtPath:[directoryURL path] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return YES;
}

+ (BOOL)removeDirectoryForEventWithName:(NSString *)name {
    NSURL *directoryURL = [self resourcesDirectoryFilePathForEventWithName:name];
    if([[NSFileManager defaultManager] fileExistsAtPath:[directoryURL path]]) {
        return [[NSFileManager defaultManager] removeItemAtURL:directoryURL error:nil];
    }
    return YES;
}

+ (NSURL *)resourcesDirectoryFilePathForEventWithName:(NSString *)eventName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths firstObject];
    NSURL *url = [NSURL fileURLWithPath:path];
    return [url URLByAppendingPathComponent:eventName];
}

@end
