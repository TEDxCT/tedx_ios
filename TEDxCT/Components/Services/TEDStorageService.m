//
//  TEDStorageService.m
//  TEDxCT
//
//  Created by Daniel Galasko on 5/19/14.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import "TEDStorageService.h"

@implementation TEDStorageService

+ (BOOL)removeResourcesForEventWithName:(NSString *)name {
    NSString *directoryURL = [self directoryForEventWithName:name];
    if([[NSFileManager defaultManager] fileExistsAtPath:directoryURL]) {
        return [[NSFileManager defaultManager] removeItemAtURL:[NSURL fileURLWithPath:directoryURL] error:nil];
    }
    return YES;
}

+ (NSString *)pathForImageWithURL:(NSString *)imageURL eventName:(NSString *)eventName createIfNeeded:(BOOL)createIfNeeded {
    NSString *directory =  [self directoryForEventWithName:eventName];
    directory = [directory stringByAppendingPathComponent:[imageURL stringByDeletingLastPathComponent]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:directory]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [directory stringByAppendingPathComponent:[imageURL lastPathComponent]];
}

+ (NSString *)directoryForEventWithName:(NSString *)eventName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths firstObject] stringByAppendingPathComponent:eventName];
    return path;
}

@end
