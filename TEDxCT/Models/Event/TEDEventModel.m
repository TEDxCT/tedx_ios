//
//  TEDEventModel.m
//  TEDxCT
//
//  Created by Carla G on 2014/05/28.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import "TEDEventModel.h"
#import "TEDApplicationConfiguration.h"
#import "TEDCoreDataManager.h"
#import "TEDEvent.h"

@implementation TEDEventModel

- (NSFetchRequest *)createEventFetchRequest {
    TEDApplicationConfiguration *config = [[TEDApplicationConfiguration alloc]init];
    NSManagedObjectContext *context = [[TEDCoreDataManager sharedManager] uiContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([TEDEvent class]) inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"name = %@", [config eventName]]];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"fullName"
                                                                   ascending:YES];
    
    NSExpressionDescription* objectIdDesc = [[NSExpressionDescription alloc] init];
    objectIdDesc.name = @"objectID";
    objectIdDesc.expression = [NSExpression expressionForEvaluatedObject];
    objectIdDesc.expressionResultType = NSObjectIDAttributeType;
    
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    return fetchRequest;
}


@end
