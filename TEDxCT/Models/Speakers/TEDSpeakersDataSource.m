//
//  TEDSpeakersDataSource.m
//  TEDxCT
//
//  Created by Daniel Galasko on 4/17/14.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import "TEDSpeakersDataSource.h"
#import "TEDSpeaker.h"
#import "TEDCoreDataManager.h"

@interface TEDSpeakersDataSource ()
@property (strong, nonatomic) NSFetchedResultsController *speakersFetchedResultsController;
@end

@implementation TEDSpeakersDataSource

- (id)init {
    self = [super init];
    if (self) {
        _speakersFetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:[self createSpeakersFetchRequest]
                                                                               managedObjectContext:[self uiContext]
                                                                                 sectionNameKeyPath:nil
                                                                                          cacheName:nil];
    }
    
    return self;
}

- (void)reloadData {
    [self.speakersFetchedResultsController performFetch:nil];
}

- (TEDSpeaker *)speakerForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.speakersFetchedResultsController objectAtIndexPath:indexPath];
}

- (NSInteger)numberOfSpeakers {
    return [[self.speakersFetchedResultsController fetchedObjects] count];
}

#pragma mark - Core Data -
- (NSFetchRequest *)createSpeakersFetchRequest {
    NSManagedObjectContext *context = [[TEDCoreDataManager sharedManager] uiContext];

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([TEDSpeaker class]) inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"isActive = YES"]];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"fullName"
                                                                   ascending:YES];
    
    NSExpressionDescription* objectIdDesc = [[NSExpressionDescription alloc] init];
    objectIdDesc.name = @"objectID";
    objectIdDesc.expression = [NSExpression expressionForEvaluatedObject];
    objectIdDesc.expressionResultType = NSObjectIDAttributeType;
    
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    return fetchRequest;
}

#pragma mark - Convenience -
- (NSManagedObjectContext *)uiContext {
    return [[TEDCoreDataManager sharedManager] uiContext];
}

@end
