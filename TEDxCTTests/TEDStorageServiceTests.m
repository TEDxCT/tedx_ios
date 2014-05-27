//
//  TEDStorageServiceTests.m
//  TEDxCT
//
//  Created by Daniel Galasko on 5/19/14.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TEDStorageService.h"

@interface TEDStorageServiceTests : XCTestCase

@end

@implementation TEDStorageServiceTests

- (void)setUp
{
    [super setUp];
    NSString *name = @"TEDTEST";
    NSURL *url = [TEDStorageService resourcesDirectoryFilePathForEventWithName:name];
    [[NSFileManager defaultManager] removeItemAtURL:url error:nil];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testFilePath
{
    NSString *name = @"TEDTEST";
    NSURL *url = [TEDStorageService resourcesDirectoryFilePathForEventWithName:name];
    XCTAssertNotNil(url, @"Storage Service returned nil");
    XCTAssertFalse([[NSFileManager defaultManager] fileExistsAtPath:[url path]], @"Path exists!!");
    
    [TEDStorageService createDirectoryForEventWithName:name];
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:[url path]], @"Path Does Not Exist!");
}

@end
