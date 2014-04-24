//
//  TEDEventTests.m
//  TEDxCT
//
//  Created by Daniel Galasko on 4/24/14.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "TEDCoreDataTestsHelper.h"
#import "TEDEvent.h"
#import "TEDSession.h"

@interface TEDEventTests : XCTestCase

@end

@implementation TEDEventTests

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

- (void)testEventCreationAndPersistence {
    NSString *eventClassName = NSStringFromClass([TEDEvent class]);
    NSManagedObjectContext *context = [TEDCoreDataTestsHelper createUIContext];
    
    NSArray *results = [context executeFetchRequest:[NSFetchRequest fetchRequestWithEntityName:eventClassName] error:nil];
    XCTAssertTrue([results count] == 0, @"There shouldnt be events here");
    TEDEvent *event = [NSEntityDescription insertNewObjectForEntityForName:eventClassName
                                                    inManagedObjectContext:context];
    NSString *eventName = @"Ted Main Event";
    event.name = eventName;
    
    NSError *error;
    [context save:&error];
    XCTAssertNil(error, @"Failed To Save With Error:%@",error);
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:eventClassName inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", eventName];
    [fetchRequest setPredicate:predicate];
    
    NSUInteger fetchedObjectsCount = [context countForFetchRequest:fetchRequest error:nil];
    XCTAssertTrue(fetchedObjectsCount == 1, @"Fetch count is not 1");
}

- (void)testEventDeletionCascadeToSessions {
    NSString *eventClassName = NSStringFromClass([TEDEvent class]);
    NSManagedObjectContext *context = [TEDCoreDataTestsHelper createUIContext];
    
    NSArray *results = [context executeFetchRequest:[NSFetchRequest fetchRequestWithEntityName:eventClassName] error:nil];
    XCTAssertTrue([results count] == 0, @"There shouldnt be events here");
    TEDEvent *event = [NSEntityDescription insertNewObjectForEntityForName:eventClassName
                                                    inManagedObjectContext:context];
    NSString *eventName = @"Ted Main Event";
    event.name = eventName;
    
    TEDSession *session = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([TEDSession class]) inManagedObjectContext:context];
    NSString *sessionName = @"Hello World";
    session.name = sessionName;
    
    [event addSessionsObject:session];
    
    NSError *error;
    [context save:&error];
    XCTAssertNil(error, @"Failed To Save With Error:%@",error);
    
    [context deleteObject:event];
    [context save:nil];

    results = [context executeFetchRequest:[NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([TEDEvent class])] error:nil];
    XCTAssertTrue([results count] == 0, @"Event was not deleted");
    
    results = [context executeFetchRequest:[NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([TEDSession class])] error:nil];
    XCTAssertTrue([results count] == 0, @"Session was not deleted");
}

@end
