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
#import "TEDSpeaker+Additions.h"
#import "TEDCoreDataManager.h"
#import <CoreData/CoreData.h>

static TEDContentImporter *sharedImporter = nil;

@interface TEDContentImporter()

@property (nonatomic, strong) TEDApplicationConfiguration *appConfig;
@property (nonatomic, strong) NSManagedObjectContext *transactionalContext;

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
                                                    
                                                }];
    
    [dataTask resume];
}

-(void)importContentFromEventJSON:(NSDictionary *)JSON {
    NSDictionary *events = JSON[@"events"];
    NSMutableArray *sessions = [[NSMutableArray alloc]init];
    NSMutableArray *talks = [[NSMutableArray alloc]init];
    NSMutableArray *speakers = [[NSMutableArray alloc]init];

    for (NSDictionary *event in events) {
        if ([event[@"name"] isEqualToString:@"TEDxTest"]) {
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
