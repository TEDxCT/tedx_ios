//
//  TEDNetworkServiceTests.m
//  TEDxCT
//
//  Created by Carla G on 2014/05/12.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TEDContentImporter.h"
#import "TEDCoreDataManager.h"
#import "TEDEvent.h"
#import "TEDSession.h"

@interface TEDContentImporterTests : XCTestCase
@property (nonatomic, weak) TEDContentImporter *contentImporter;
@property (nonatomic, weak) NSString *eventName;
@end

@implementation TEDContentImporterTests

- (void)setUp
{
    [super setUp];
    self.contentImporter = [TEDContentImporter sharedImporter];
    self.eventName = @"TestEvent";

    [self removeAllDataForAllEvents];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [self removeAllDataForAllEvents];
    [super tearDown];
}


- (void)testRemoveAllDataForEvent {
    
    [self removeAllDataForAllEvents];
    NSArray *events = [self fetchAllEvents];
    XCTAssertFalse([events count]>0, @"Failed to remove all events from database");

    NSArray *sessions = [self fetchAllSessions];
    XCTAssertFalse([sessions count]>0, @"Failed to remove all sessions from database");
}


- (void)testRequestInitialContentImportForEvent {
    NSDictionary * json = [self requestEvent1JSON];
    XCTAssert(json, @"JSON is null or empty");
    
    [self importContentFromJSON:json forEventName:self.eventName];
    NSArray *initiallyImportedEvents = [self fetchEventNamed:self.eventName isInTrash:NO];
    XCTAssertTrue([initiallyImportedEvents count]==1, @"Should have only one event in %@", self.eventName);
}


- (void)testTrashingEventForUpdatedEvent {
    NSDictionary * json1 = [self requestEvent1JSON];
    XCTAssert(json1, @"JSON is null or empty");
    
    [self importContentFromJSON:json1 forEventName:self.eventName];
    NSArray *initiallyImportedEvents = [self fetchEventNamed:self.eventName isInTrash:NO];
    XCTAssertTrue([initiallyImportedEvents count]==1, @"Should have only one event in %@", self.eventName);

    
    NSDictionary * json2 = [self requestEvent2JSON];
    XCTAssert(json2, @"JSON is null or empty");
    
    [self importContentFromJSON:json2 forEventName:self.eventName];
    NSArray *updatedImportedEvents = [self fetchEventNamed:self.eventName isInTrash:YES];
    XCTAssertTrue([updatedImportedEvents count]==1, @"Should have only trashed event in %@", self.eventName);
}

- (void)testDeletingTrashedEvent {
    NSDictionary * json1 = [self requestEvent1JSON];
    XCTAssert(json1, @"JSON is null or empty");
    
    [self importContentFromJSON:json1 forEventName:self.eventName];
    NSArray *initiallyImportedEvents = [self fetchEventNamed:self.eventName isInTrash:NO];
    XCTAssertTrue([initiallyImportedEvents count]==1, @"Should have only one event in %@", self.eventName);
    
    
    NSDictionary * json2 = [self requestEvent2JSON];
    XCTAssert(json2, @"JSON is null or empty");
    
    [self importContentFromJSON:json2 forEventName:self.eventName];
    NSArray *updatedImportedEvents = [self fetchEventNamed:self.eventName isInTrash:YES];
    XCTAssertTrue([updatedImportedEvents count]==1, @"Should have only trashed event in %@", self.eventName);
    
    [self deleteTrashedContentForEventName:self.eventName];
    NSArray *trashedEvents = [self fetchEventNamed:self.eventName isInTrash:YES];
    XCTAssertTrue([trashedEvents count]==0, @"Should have 0 trashed events in %@", self.eventName);
    
    NSArray *events = [self fetchEventNamed:self.eventName isInTrash:NO];
    XCTAssertTrue([events count]==0, @"Should have 0 events in %@", self.eventName);
}

- (void)testUpdatingEventAfterBeingTashed {
    NSDictionary * json1 = [self requestEvent1JSON];
    XCTAssert(json1, @"JSON is null or empty");
    
    [self importContentFromJSON:json1 forEventName:self.eventName];
    NSArray *initiallyImportedEvents = [self fetchEventNamed:self.eventName isInTrash:NO];
    XCTAssertTrue([initiallyImportedEvents count]==1, @"Should have only one event in %@", self.eventName);
    
    
    NSDictionary * json2 = [self requestEvent2JSON];
    XCTAssert(json2, @"JSON is null or empty");
    
    [self importContentFromJSON:json2 forEventName:self.eventName];
    NSArray *updatedImportedEvents = [self fetchEventNamed:self.eventName isInTrash:YES];
    XCTAssertTrue([updatedImportedEvents count]==1, @"Should have only trashed event in %@", self.eventName);
    
    [self deleteTrashedContentForEventName:self.eventName];
    NSArray *trashedEvents = [self fetchEventNamed:self.eventName isInTrash:YES];
    XCTAssertTrue([trashedEvents count]==0, @"Should have 0 trashed events in %@", self.eventName);
    
    NSArray *events = [self fetchEventNamed:self.eventName isInTrash:NO];
    XCTAssertTrue([events count]==0, @"Should have 0 events in %@", self.eventName);
    
    [self importContentFromJSON:json2 forEventName:self.eventName];
    NSArray *reimportedEvent = [self fetchEventNamed:self.eventName isInTrash:NO];
    XCTAssertTrue([reimportedEvent count]==1, @"Should have only trashed event in %@", self.eventName);
    TEDEvent *event = [reimportedEvent firstObject];
    XCTAssertTrue([event.identifier isEqualToNumber:[NSNumber numberWithInteger:333]], @"Updated event Id should be 333 for event named %@", self.eventName);
}


- (void)deleteTrashedContentForEventName:(NSString *)eventName {
    __block BOOL hasCalledBack = NO;
    
    void (^completionBlock)(void) = ^(void){
        NSLog(@"Completion Block!");
        hasCalledBack = YES;
    };
    
    [self.contentImporter deleteContentInTrashWithCompletionBlock:completionBlock];
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:10];
    while (hasCalledBack == NO && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:loopUntil];
    }
    
    if (!hasCalledBack)
    {
        XCTFail(@"I know this will fail, thanks");
    }
}

- (void)importContentFromJSON:(NSDictionary *)json forEventName:(NSString *)eventName {
    __block BOOL hasCalledBack = NO;
    
    void (^completionBlock)(void) = ^(void){
        NSLog(@"Completion Block!");
        hasCalledBack = YES;
        [self checkEventExists:eventName];

    };
    
    [self.contentImporter importContentFromEventJSON:json forEventName:eventName withCompletionBlock:completionBlock];
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:10];
    while (hasCalledBack == NO && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:loopUntil];
    }
    
    if (!hasCalledBack)
    {
        XCTFail(@"I know this will fail, thanks");
    }
}

- (void)checkEventExists:(NSString *)eventName {
    NSManagedObjectContext *context =self.contentImporter.transactionalContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([TEDEvent class]) inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = Event1"];
    //    [fetchRequest setPredicate:predicate];
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"identifier"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    XCTAssertNotNil(fetchedObjects, @"DID NOT SAVE EVENT WITH NAME: %@", eventName);
}


- (NSDictionary *)requestEvent1JSON {
    NSData *data =  [[NSFileManager defaultManager] contentsAtPath:[self event1JSONURL]];
    
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:data
                          
                          options:kNilOptions
                          error:&error];
    
    return json;
    
}

- (NSDictionary *)requestEvent2JSON {
    NSData *data =  [[NSFileManager defaultManager] contentsAtPath:[self event2JSONURL]];
    
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:data
                          
                          options:kNilOptions
                          error:&error];
    
    return json;
    
}


- (void)removeAllDataForAllEvents {
    NSManagedObjectContext *context = self.contentImporter.transactionalContext;
    NSArray *fetchedObjects = [self fetchAllEvents];
    if (fetchedObjects) {
        for (NSManagedObject *objectToDelete in fetchedObjects){
            [context deleteObject:objectToDelete];
        }
        [context save:nil];
    }
}

- (NSArray *)fetchEventNamed:(NSString *)eventName isInTrash:(BOOL)isInTrash{
    NSManagedObjectContext *context = self.contentImporter.transactionalContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([TEDEvent class]) inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"name = %@ and isTrashed = %@", eventName, [NSNumber numberWithBool:isInTrash]];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"identifier"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    return fetchedObjects;
}

- (NSArray *)fetchAllEvents {
    NSManagedObjectContext *context = self.contentImporter.transactionalContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([TEDEvent class]) inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"identifier"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    return fetchedObjects;
}

- (NSArray *)fetchAllSessions {
    NSManagedObjectContext *context = self.contentImporter.transactionalContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([TEDSession class]) inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"identifier"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    return fetchedObjects;
}


- (NSString *)event1JSONURL {
    return [[NSBundle bundleForClass:[self class]] pathForResource:@"Event1" ofType:@"json"];
}

- (NSString *)event2JSONURL {
    return [[NSBundle bundleForClass:[self class]] pathForResource:@"Event2" ofType:@"json"];
}


@end
