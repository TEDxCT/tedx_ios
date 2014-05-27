//
//  TEDxCTTests.m
//  TEDxCTTests
//
//  Created by Carla G on 2014/03/31.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TEDCoreDataMocker.h"
#import "TEDSpeaker.h"
#import "TEDSession.h"
#import "TEDCoreDataManager.h"
#import <CoreData/CoreData.h>

@interface TEDxCTTests : XCTestCase

@end

@implementation TEDxCTTests

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

- (void)testCreateFakeSpeakers
{
    TEDCoreDataMocker *mocker = [[TEDCoreDataMocker alloc]init];
    [mocker create2Speakers];
    
    NSManagedObjectContext *context = [[TEDCoreDataManager sharedManager] uiContext];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([TEDSpeaker class])];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    
    NSError *error;
    NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
    
    XCTAssertNil(error, @"Failed while retrieving speakers");
    
    XCTAssertEqual([results count], 5, @"Did not return correct number of speakers");
}

-(void)testCreateFakeSessions
{
    TEDCoreDataMocker *mocker = [[TEDCoreDataMocker alloc]init];
    [mocker create2Sessions];
    
    NSManagedObjectContext *context = [[TEDCoreDataManager sharedManager] uiContext];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([TEDSession class])];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    
    NSError *error;
    NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
    
    XCTAssertNil(error, @"Failed while retrieving sessions");
    
    XCTAssertEqual([results count], 1, @"Did not return correct number of sessions");

}

@end
