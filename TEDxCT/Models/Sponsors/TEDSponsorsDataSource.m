//
//  TEDSponsorsDataSource.m
//  TEDxCT
//
//  Created by Carla G on 2014/06/25.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import "TEDSponsorsDataSource.h"
#import "TEDApplicationConfiguration.h"
#import "TEDCoreDataManager.h"
#import "TEDImageDownloader.h"
#import "TEDSponsor.h"

@interface TEDSponsorsDataSource()

@property (strong, nonatomic) TEDImageDownloader *imageDownloader;

@end

@implementation TEDSponsorsDataSource

-(id)init {
    if (self = [super init]) {
    }
    
    return self;
}

- (NSFetchRequest *)createSponsorsFetchRequest {
    NSManagedObjectContext *context = [[TEDCoreDataManager sharedManager] uiContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([TEDSponsor class]) inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                                   ascending:YES];
    
    NSExpressionDescription* objectIdDesc = [[NSExpressionDescription alloc] init];
    objectIdDesc.name = @"objectID";
    objectIdDesc.expression = [NSExpression expressionForEvaluatedObject];
    objectIdDesc.expressionResultType = NSObjectIDAttributeType;
    
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    return fetchRequest;
}

@end
