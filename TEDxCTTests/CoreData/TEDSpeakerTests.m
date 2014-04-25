//
//  TEDSpeakerTests.m
//  TEDxCT
//
//  Created by Daniel Galasko on 4/25/14.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "TEDCoreDataTestsHelper.h"
#import "TEDSpeaker.h"

@interface TEDSpeakerTests : XCTestCase

@end

@implementation TEDSpeakerTests

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

- (void)testSpeakerIsVisibleDefaultsToYes {
    NSManagedObjectContext *context = [TEDCoreDataTestsHelper createUIContext];
    TEDSpeaker *speaker = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([TEDSpeaker class]) inManagedObjectContext:context];
    [context save:nil];
    XCTAssertTrue(speaker.isActive, @"The speaker has not defaulted to yes");
}

@end
