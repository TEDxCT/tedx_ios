//
//  TEDNetworkImporter.m
//  TEDxCT
//
//  Created by Carla G on 2014/05/12.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import "TEDContentImporter.h"
#import "TEDApplicationConfiguration.h"
#import "TEDSpeaker.h"
#import "TEDTalk.h"
#import "TEDSession.h"
#import "TEDSpeaker+Additions.h"
#import "TEDTalk+Additions.h"
#import "TEDSession+Additions.h"
#import "TEDCoreDataManager.h"
#import <CoreData/CoreData.h>

static TEDContentImporter *sharedImporter = nil;

@interface TEDContentImporter()

@property (nonatomic, strong) TEDApplicationConfiguration *appConfig;
@property (nonatomic, strong) NSManagedObjectContext *transactionalContext;
@property (nonatomic, strong) NSOperationQueue *operationQueue;

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

    });
}

- (void)requestContentImportForAllContent {
    [self requestEventJSONWithCompletionHandler:^(NSDictionary *json) {
        [self importContentFromEventJSON:json];
    }];
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

-(void)importContentFromEventJSON:(NSDictionary *)JSON {
    NSDictionary *events = JSON[@"events"];
    NSMutableArray *sessions = [[NSMutableArray alloc]init];
//    NSMutableArray *talks = [[NSMutableArray alloc]init];
//    NSMutableArray *speakers = [[NSMutableArray alloc]init];
//
    for (NSDictionary *event in events) {
        if ([event[@"name"] isEqualToString:@"Alex's house"]) {
            sessions = event[@"sessions"];
        }
    }
//
//    for (NSDictionary *session in sessions) {
//        [talks addObject:session[@"talks"]];
//    }
//
//    for (NSDictionary *talk in talks) {
//        NSDictionary *talkTalk = [(NSArray *)talk objectAtIndex:0];
//        [speakers addObject:talkTalk[@"speaker"]];
//        
//    }
    
    [self importSessions:sessions WithCompletionHandler:^{
                [[self transactionalContext] save:nil];
                [[self transactionalContext].parentContext save:nil];
    }];

}

- (void)importSessions:(NSArray *)sessions
WithCompletionHandler:(void(^)())completionBlock {
    
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([TEDSession class])];
    fetch.resultType = NSDictionaryResultType;

    
    [[self transactionalContext] performBlock:^{
        NSArray *results = [[self transactionalContext] executeFetchRequest:fetch error:nil];
        
        NSDictionary *sessionsKeyedByIdentifier = [NSDictionary dictionaryWithObjects:results forKeys:[results valueForKey:@"identifier"]];
        
        for (NSDictionary *session in sessions) {
            NSNumber *idToCheck = [NSNumber numberWithInteger:[session[@"id"] intValue]];
            TEDTalk *existingTalk = [sessionsKeyedByIdentifier objectForKey:idToCheck];
            if (existingTalk) {
                //update
            } else {
                //insert
                TEDSession *newSession = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([TEDSession class]) inManagedObjectContext:[self transactionalContext]
                                    ];
                [newSession populateSessionWithDictionary:session];

                if (session[@"talks"]) {
                [self importTalks:session[@"talks"] forSession:newSession WithCompletionHandler:^(NSSet *importedObjects) {
                    [newSession addTalks:importedObjects];
                    
                    if(completionBlock){
                        completionBlock();
                    }
                }];
                }
                else {
                    if (completionBlock) {
                        completionBlock();
                    }
                }
            }
            
        }
        

    }];
    
}


- (void)importTalks:(NSArray *)talks
         forSession:(TEDSession *)session
WithCompletionHandler:(void (^)(NSSet *importedObjects))completionBlock {
    
    NSMutableSet *importedTalks = [[NSMutableSet alloc]init];
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([TEDTalk class])];
    fetch.resultType = NSDictionaryResultType;
    
    [[self transactionalContext] performBlock:^{
        NSArray *results = [[self transactionalContext] executeFetchRequest:fetch error:nil];
        
        NSDictionary *talksKeyedByIdentifier = [NSDictionary dictionaryWithObjects:results forKeys:[results valueForKey:@"name"]];
        
        if ([talks isKindOfClass:[NSNull class]]) {
            if(completionBlock){
                completionBlock(nil);
                return;
            }
        }
        for (NSDictionary *talk in talks) {

            NSNumber *nameToCheck = talk[@"name"];
            TEDTalk *existingTalk = [talksKeyedByIdentifier objectForKey:nameToCheck];
            if (existingTalk) {
                //update
            } else {
                //insert
                TEDTalk *newTalk = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([TEDTalk class]) inManagedObjectContext:[self transactionalContext]
                                          ];
                
                [self importSpeaker:talk[@"speaker"] WithCompletionHandler:^(TEDSpeaker *importedSpeaker) {
                    newTalk.speaker = importedSpeaker;
                    newTalk.session = session;
                    [newTalk populateTalkWithDictionary:talk];
                    
                    if(completionBlock){
                        completionBlock(importedTalks);
                    }

                }];
                
                


            }
            
        }

        
    }];
    
}

- (void)importSpeakers:(NSArray *)speakers
 WithCompletionHandler:(void (^)(NSSet *importedObjects))completionBlock {
    NSMutableSet *importedObjects = [[NSMutableSet alloc]init];
    
    NSArray *speakerIDs = [speakers valueForKey:@"id"];
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([TEDSpeaker class])];
    fetch.predicate = [NSPredicate predicateWithFormat:@"identifier in %@",speakerIDs];
    fetch.resultType = NSDictionaryResultType;

    
    [[self transactionalContext] performBlock:^{
        NSArray *results = [[self transactionalContext] executeFetchRequest:fetch error:nil];
        
        NSDictionary *speakersKeyedByIdentifier = [NSDictionary dictionaryWithObjects:results forKeys:[results valueForKey:@"identifier"]];
        
        for (NSDictionary *speaker in speakers) {
            NSNumber *idToCheck = [NSNumber numberWithInteger:[speaker[@"id"] intValue]];
            TEDSpeaker *existingSpeaker = [speakersKeyedByIdentifier objectForKey:idToCheck];
            if (existingSpeaker) {
                //update
            } else {
                //insert
                TEDSpeaker *newSpeaker = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([TEDSpeaker class]) inManagedObjectContext:[self transactionalContext]
                                          ];
                [newSpeaker populateSpeakerWithDictionary:speaker];
                [importedObjects addObject:newSpeaker];
                
                if(completionBlock){
                    completionBlock(importedObjects);
                }
                
            }
            
        }
        

    }];
}

- (void)importSpeaker:(NSDictionary *)speaker
 WithCompletionHandler:(void (^)(TEDSpeaker *importedSpeaker))completionBlock {
    
    NSString *speakerID = [speaker objectForKey:@"id"];
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([TEDSpeaker class])];
    fetch.predicate = [NSPredicate predicateWithFormat:@"identifier == %@",speakerID];
    fetch.resultType = NSDictionaryResultType;
    
    [[self transactionalContext] performBlock:^{
        NSArray *results = [[self transactionalContext] executeFetchRequest:fetch error:nil];
        
        NSDictionary *speakersKeyedByIdentifier = [NSDictionary dictionaryWithObjects:results forKeys:[results valueForKey:@"identifier"]];
        
            NSNumber *idToCheck = [NSNumber numberWithInteger:[speaker[@"id"] intValue]];
            TEDSpeaker *existingSpeaker = [speakersKeyedByIdentifier objectForKey:idToCheck];
            if (existingSpeaker) {
                //update
            } else {
                //insert
                TEDSpeaker *newSpeaker = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([TEDSpeaker class]) inManagedObjectContext:[self transactionalContext]
                                          ];
                [newSpeaker populateSpeakerWithDictionary:speaker];
                if (completionBlock) {
                    completionBlock(newSpeaker);
                }
            }
        
    }];
}


#pragma mark - Convenience -
- (NSManagedObjectContext *)uiContext {
    return [[TEDCoreDataManager sharedManager] uiContext];
}

- (NSManagedObjectContext *)transactionalContext {
    if (!_transactionalContext) {
        NSManagedObjectContext *transactionalContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        NSManagedObjectContext *parentContext = [self uiContext];
        transactionalContext.parentContext = parentContext;
        _transactionalContext = transactionalContext;
    }
    return _transactionalContext;
}

@end
