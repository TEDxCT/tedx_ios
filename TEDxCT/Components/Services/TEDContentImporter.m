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
#import "TEDSpeaker+Additions.h"
#import "TEDCoreDataManager.h"
#import <CoreData/CoreData.h>
#import "TEDDownloadOperation.h"

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
    TEDDownloadOperation *downloadOperation = [TEDDownloadOperation operationWithRemoteURL:[self.appConfig eventJSONURL]
                                                                                   success:^(NSOperation *operation, id responseObject) {
                                                                                       if (completionBlock) {
                                                                                           completionBlock(responseObject);
                                                                                       }
                                                                                   } failure:^(NSOperation *operation, NSError *error) {
                                                                                       NSLog(@"error!");
                                                                                   }];
    
    [self.operationQueue addOperation:downloadOperation];
    
}

-(void)importContentFromEventJSON:(NSDictionary *)JSON {
    NSDictionary *events = JSON[@"events"];
    NSMutableArray *sessions = [[NSMutableArray alloc]init];
    NSMutableArray *talks = [[NSMutableArray alloc]init];
    NSMutableArray *speakers = [[NSMutableArray alloc]init];

    for (NSDictionary *event in events) {
        if ([event[@"name"] isEqualToString:@"Alex's house"]) {
            sessions = event[@"sessions"];
        }
    }
    
    for (NSDictionary *session in sessions) {
        [talks addObject:session[@"talks"]];
    }
    
    for (NSDictionary *talk in talks) {
        NSDictionary *talk1 = [(NSArray *)talk objectAtIndex:0];
        [speakers addObject:talk1[@"speaker"]];
    }
    
    [self importSpeakers:speakers WithCompletionHandler:^{
        [[self transactionalContext] save:nil];
        [[self transactionalContext].parentContext save:nil];
    }];
}

- (void)importSpeakers:(NSArray *)speakers
 WithCompletionHandler:(void(^)())completionBlock {

        NSArray *speakerIDs = [speakers valueForKey:@"id"];
        NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([TEDSpeaker class])];
        fetch.predicate = [NSPredicate predicateWithFormat:@"identifier in %@",speakerIDs];
    
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
            }
            
        }
        
        if(completionBlock){
            completionBlock();
        }

    }];
    
}

- (void)importTalks:(NSArray *)talks
 WithCompletionHandler:(void(^)())completionBlock {
    
    NSArray *talkIds = [talks valueForKey:@"id"];
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([TEDTalk class])];
    fetch.predicate = [NSPredicate predicateWithFormat:@"identifier in %@",talkIds];
    
    [[self transactionalContext] performBlock:^{
        NSArray *results = [[self transactionalContext] executeFetchRequest:fetch error:nil];
        
        NSDictionary *speakersKeyedByIdentifier = [NSDictionary dictionaryWithObjects:results forKeys:[results valueForKey:@"identifier"]];
        
        for (NSDictionary *speaker in results) {
            NSNumber *idToCheck = [NSNumber numberWithInteger:[speaker[@"id"] intValue]];
            TEDSpeaker *existingSpeaker = [speakersKeyedByIdentifier objectForKey:idToCheck];
            if (existingSpeaker) {
                //update
            } else {
                //insert
                TEDSpeaker *newSpeaker = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([TEDSpeaker class]) inManagedObjectContext:[self transactionalContext]
                                          ];
                [newSpeaker populateSpeakerWithDictionary:speaker];
            }
            
        }
        
        if(completionBlock){
            completionBlock();
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
