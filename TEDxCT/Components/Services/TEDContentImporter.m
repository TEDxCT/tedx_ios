//
//  TEDNetworkImporter.m
//  TEDxCT
//
//  Created by Carla G on 2014/05/12.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import "TEDContentImporter.h"
#import "TEDApplicationConfiguration.h"
#import "TEDCoreDataManager.h"
#import "TEDSession+Additions.h"
#import "TEDSession.h"
#import "TEDSpeaker+Additions.h"
#import "TEDSpeaker.h"
#import "TEDTalk+Additions.h"
#import "TEDTalk.h"
#import "TEDEvent.h"
#import "TEDEvent+Additions.h"
#import "TEDSponsor.h"
#import "TEDSponsor+Additions.h"
#import <CoreData/CoreData.h>

#define IMPORTER_LOGGER 0

#if IMPORTER_LOGGER == 1
#	define ITLog(fmt, ...) NSLog((fmt), ##__VA_ARGS__);
#else
#	define ITLog(...)
#endif

static TEDContentImporter *sharedImporter = nil;
NSString *const kNameKey = @"name";
NSString *const kSessionsKey = @"sessions";
NSString *const kEventsKey = @"events";
NSString *const kTalksKey = @"talks";
NSString *const kSpeakerKey = @"speaker";
NSString *const kSponsorsKey = @"sponsors";


@interface TEDContentImporter()

@property (nonatomic, strong) TEDApplicationConfiguration *appConfig;
@property (nonatomic, strong) NSManagedObjectContext *transactionalContext;
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSDateFormatter *timeFormatter;

@end

@implementation TEDContentImporter

+ (TEDContentImporter *)sharedImporter {
    return sharedImporter;
}

+ (void)initialiseSharedImporter {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedImporter = [[TEDContentImporter alloc] init];
        sharedImporter.appConfig = [[TEDApplicationConfiguration alloc]init];
        sharedImporter.operationQueue = [[NSOperationQueue alloc] init];
        [sharedImporter.operationQueue setMaxConcurrentOperationCount:1];

        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        
        NSDateFormatter *tf = [[NSDateFormatter alloc] init];
        [tf setDateFormat:@"HH:mm"];
        
        sharedImporter.dateFormatter = df;
        sharedImporter.timeFormatter = tf;
    });
}

- (void)requestContentImportForAllContent {

    [self requestEventJSONWithCompletionHandler:^(NSDictionary *json) {
        if (json) {
            [self deleteContentInTrashWithCompletionBlock:nil];
            
            ITLog(@"START IMPORT");
            [self importContentFromEventJSON:json forEventName:[self.appConfig eventName] withCompletionBlock:nil];
        }
    }];
    
    [self requestSponsorJSONWithCompletionHandler:^(NSDictionary *json) {
        if (json) {
            [self importContentFromSponsorJSON:json];
        }
    }];
}

#pragma mark - Trash -
- (void)deleteContentInTrashWithCompletionBlock:(void(^)())completionBlock {
    [self.transactionalContext performBlock:^{
        NSArray *trashedEvents = [self trashedEvents];
        
        for (TEDEvent *trashedEvent in trashedEvents) {
            [self.transactionalContext deleteObject:trashedEvent];
        }
        
        ITLog(@"TAKING OUT TRASH COMPLETE");
        [self.transactionalContext save:nil];
        if(completionBlock) {
            completionBlock();
        }
    }];
}

- (NSArray *)trashedEvents {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([TEDEvent class])];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isTrashed = YES"];
    [fetchRequest setPredicate:predicate];
    NSError *error = nil;
    NSArray *fetchedObjects = [self.transactionalContext executeFetchRequest:fetchRequest error:&error];

    return fetchedObjects;
}

#pragma mark - Import -


#pragma mark - Import Sponsors -
- (void)importContentFromSponsorJSON:(NSDictionary *)JSON {
    NSDictionary *sponsors = JSON[kSponsorsKey];
    
    for (NSDictionary *sponsor in sponsors) {
            [self importSponsor:sponsor withCompletionHandler:^{
                ITLog(@"IMPORT SPONSOR COMPLETE");
                [self.transactionalContext save:nil];
                [self.transactionalContext.parentContext save:nil];
            }];
    }
}

#pragma mark - Import Content -
-(void)importContentFromEventJSON:(NSDictionary *)JSON forEventName:(NSString *)eventName withCompletionBlock:(void(^)())completionBlock {
    //Get events from JSON
    NSDictionary *events = JSON[kEventsKey];
    
    for (NSDictionary *event in events) {
        if ([event[kNameKey] isEqualToString:eventName]) {
            [self importEvent:event withCompletionHandler:^{
                ITLog(@"IMPORT COMPLETE");
                [self.transactionalContext save:nil];
                [self.transactionalContext.parentContext save:nil];
                dispatch_async(dispatch_get_main_queue(),^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:kContentImporterCompleteNotification object:nil];
                    if (completionBlock){
                        completionBlock();
                    }

                });
                
            }];
        }
    }
    

}

- (void)importEvent:(NSDictionary *)event withCompletionHandler:(void(^)())completionBlock  {
    
    [self.transactionalContext performBlock:^{
        NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([TEDEvent class])];
        fetch.resultType = NSDictionaryResultType;
        NSArray *results = [self.transactionalContext executeFetchRequest:fetch error:nil];
        NSDictionary *eventsKeyedByName = [NSDictionary dictionaryWithObjects:results forKeys:[results valueForKey:@"name"]];
    
            NSNumber *nameToCheck = event[@"name"];

            NSDictionary *existingEvent = [eventsKeyedByName objectForKey:nameToCheck];
            if (existingEvent) {
                //update
                NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([TEDEvent class])];
                fetchRequest.predicate = [NSPredicate predicateWithFormat:@"name = %@", nameToCheck];
                
                TEDEvent *eventToUpdate = [self.transactionalContext executeFetchRequest:fetchRequest error:nil].firstObject;
                NSNumber *idToCheck = [NSNumber numberWithInteger:[event[@"id"] intValue]];

                if ([eventToUpdate.identifier isEqualToNumber:idToCheck]) {
                    [self importSessions:event[kSessionsKey]];
                } else {
                    //TRASH EVENT
                    eventToUpdate.isTrashed = [NSNumber numberWithBool:YES];
                }
            } else {
                ITLog(@"INSERTING NEW EVENT WITH ID: %@", event[@"id"]);
                
                //insert
                TEDEvent *newEvent = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([TEDEvent class]) inManagedObjectContext:self.transactionalContext];
                [newEvent populateEventWithDictionary:event];
                
                if (event[kSessionsKey]) {
                    NSSet *importedSessions = [self importSessions:event[kSessionsKey]];
                    [newEvent addSessions:importedSessions];
                }
            }


        
        
        if(completionBlock){
            completionBlock();
        }
    }];
    
}

- (NSSet *)importSessions:(NSArray *)sessions
{
        NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([TEDSession class])];
        fetch.resultType = NSDictionaryResultType;
        NSArray *results = [self.transactionalContext executeFetchRequest:fetch error:nil];
        NSDictionary *sessionsKeyedByIdentifier = [NSDictionary dictionaryWithObjects:results forKeys:[results valueForKey:@"identifier"]];
    
        NSMutableSet *importedSessions = [[NSMutableSet alloc]init];

        for (NSDictionary *session in sessions) {
            NSNumber *idToCheck = [NSNumber numberWithInteger:[session[@"id"] intValue]];
            TEDSession *existingSession = [sessionsKeyedByIdentifier objectForKey:idToCheck];
            if (existingSession) {
                //update
                [self importTalks:session[kTalksKey] forSession:existingSession];
            } else {
                ITLog(@"INSERTING NEW SESSION WITH ID: %@", session[@"id"]);
                
                //insert
                TEDSession *newSession = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([TEDSession class]) inManagedObjectContext:self.transactionalContext];
                [newSession populateSessionWithDictionary:session withDateFromatter:self.dateFormatter andTimeFormatter:self.timeFormatter];
                
                if (session[kTalksKey]) {
                    NSSet *importedTalks =    [self importTalks:session[kTalksKey] forSession:newSession];
                    [newSession addTalks:importedTalks];
                    [importedSessions addObject:newSession];
                }
            }
        }
    
    return importedSessions;
}


- (NSSet *)importTalks:(NSArray *)talks
            forSession:(TEDSession *)session {
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([TEDTalk class])];
    fetch.resultType = NSDictionaryResultType;
    NSArray *results = [self.transactionalContext executeFetchRequest:fetch error:nil];
    NSDictionary *talksKeyedByIdentifier = [NSDictionary dictionaryWithObjects:results forKeys:[results valueForKey:@"identifier"]];
    
    NSMutableSet *importedTalks = [[NSMutableSet alloc]init];
    
    if ([talks isKindOfClass:[NSNull class]]) {
        ITLog(@"NO TALKS TO IMPORT");
        return nil;
    }
    
    for (NSDictionary *talk in talks) {
        
        NSNumber *idToCheck = [NSNumber numberWithInteger:[talk[@"id"] intValue]];
        TEDTalk *existingTalk = [talksKeyedByIdentifier objectForKey:idToCheck];
        if (existingTalk) {
            [self importSpeaker:talk[kSpeakerKey]];
        } else {
            //insert
            ITLog(@"INSERTING NEW TALK: %@", talk[kNameKey]);
            
            TEDTalk *newTalk = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([TEDTalk class]) inManagedObjectContext:self.transactionalContext];
            
            TEDSpeaker * importedSpeaker = [self importSpeaker:talk[kSpeakerKey]];
            newTalk.speaker = importedSpeaker;
            newTalk.session = session;
            [newTalk populateTalkWithDictionary:talk];
            [importedTalks addObject:newTalk];
        }
    }
    
    ITLog(@"FINISHED IMPORTING %lu TALKS", (unsigned long)[importedTalks count])
    return importedTalks;
    
    
}

- (TEDSpeaker *)importSpeaker:(NSDictionary *)speaker {
    
    if ([speaker[@"fullName"] isEqualToString:@"default"]){
        return nil;
    }
        NSString *speakerID = [speaker objectForKey:@"id"];
        NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([TEDSpeaker class])];
        fetch.predicate = [NSPredicate predicateWithFormat:@"identifier == %@",speakerID];
        NSArray *results = [self.transactionalContext executeFetchRequest:fetch error:nil];
        
        NSDictionary *speakersKeyedByIdentifier = [NSDictionary dictionaryWithObjects:results forKeys:[results valueForKey:@"identifier"]];
        
        NSNumber *idToCheck = [NSNumber numberWithInteger:[speaker[@"id"] intValue]];
        TEDSpeaker *existingSpeaker = [speakersKeyedByIdentifier objectForKey:idToCheck];
        if (existingSpeaker) {
            [existingSpeaker populateSpeakerWithDictionary:speaker];
            return existingSpeaker;
        } else {
            //insert
            ITLog(@"INSERTING NEW SPEAKER WITH ID: %@", idToCheck);

            TEDSpeaker *newSpeaker = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([TEDSpeaker class]) inManagedObjectContext:self.transactionalContext
                                      ];
            [newSpeaker populateSpeakerWithDictionary:speaker];
            return newSpeaker;
        }
}

- (void)importSponsor:(NSDictionary *)sponsor withCompletionHandler:(void(^)())completionBlock {
    [self.transactionalContext performBlock:^{
        NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([TEDSponsor class])];
        fetch.resultType = NSDictionaryResultType;
        NSArray *results = [self.transactionalContext executeFetchRequest:fetch error:nil];
        NSDictionary *sponsorsKeyedByIdentifier = [NSDictionary dictionaryWithObjects:results forKeys:[results valueForKey:@"identifier"]];
        
        NSNumber *idToCheck = [NSNumber numberWithInteger:[sponsor[@"id"] intValue]];
        TEDSponsor *existingSponsor = [sponsorsKeyedByIdentifier objectForKey:idToCheck];
        if (existingSponsor) {
            //update
        } else {
            ITLog(@"INSERTING NEW SPONSOR WITH ID: %@", sponsor[@"id"]);
            
            //insert
            TEDSponsor *newSponsor = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([TEDSponsor class]) inManagedObjectContext:self.transactionalContext];
            [newSponsor populateSponsorWithDictionary:sponsor];
            
        }
        
        if(completionBlock){
            completionBlock();
        }
    }];
}

#pragma mark - Network Requests -
- (void)requestSponsorJSONWithCompletionHandler:(void(^)(NSDictionary *json))completionBlock {
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[self.appConfig sponsorsJSONURL]];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if(!error){
                                                        NSDictionary *json = [NSJSONSerialization
                                                                              JSONObjectWithData:data
                                                                              options:kNilOptions
                                                                              error:&error];
                                                        if(completionBlock) {
                                                            completionBlock(json);
                                                        }
                                                        
                                                    }
                                                    else {
                                                        NSLog(@"ERROR: %@", error);
                                                    }
                                                }];
    [dataTask resume];
}


- (void)requestEventJSONWithCompletionHandler:(void(^)(NSDictionary *json))completionBlock {
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[self.appConfig eventJSONURL]];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if(!error){
                                                        NSDictionary *json = [NSJSONSerialization
                                                                              JSONObjectWithData:data
                                                                              options:kNilOptions
                                                                              error:&error];
                                                        if(completionBlock) {
                                                            completionBlock(json);
                                                        }
                                                        
                                                    }
                                                    else {
                                                        NSLog(@"ERROR: %@", error);
                                                    }
                                                }];
    [dataTask resume];
    
}


#pragma mark - Convenience -
- (NSManagedObjectContext *)uiContext {
    return [[TEDCoreDataManager sharedManager] uiContext];
}

- (NSManagedObjectContext *)transactionalContext {
    if (!_transactionalContext) {
        NSManagedObjectContext *transactionalContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
//        NSManagedObjectContext *parentContext = [self uiContext];
//        transactionalContext.parentContext = parentContext;
        [transactionalContext setUndoManager:nil];
        [transactionalContext setPersistentStoreCoordinator:[self uiContext].persistentStoreCoordinator];
        transactionalContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
        
        _transactionalContext = transactionalContext;
    }
    return _transactionalContext;
}

@end
