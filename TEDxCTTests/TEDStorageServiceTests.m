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
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDirectoryCreation
{
    NSString *name = @"TEDTEST";
    [TEDStorageService pathForImageWithURL:@"helloworld" eventName:name createIfNeeded:NO];
    XCTFail(@"Not Implemented Yet %s",__PRETTY_FUNCTION__);
}

@end
