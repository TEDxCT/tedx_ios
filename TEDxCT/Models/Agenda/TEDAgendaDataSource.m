//
//  TEDAgendaDataSource.m
//  TEDxCT
//
//  Created by Daniel Galasko on 4/2/14.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import "TEDAgendaDataSource.h"
#import "TEDTalkTableViewCell.h"
#import "TEDTalk.h"
#import "TEDSpeaker.h"
#import "TEDCoreDataManager.h"

NSString *const kTalkCellReuseIdentifier = @"talkCell";

@interface TEDAgendaDataSource ()

@property (strong, nonatomic) NSFetchedResultsController *sessionsFetchedResultsController;

@end

@implementation TEDAgendaDataSource

- (id)init {
    self = [super init];
    if (self) {
        _sessionsFetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:[self createSessionsFetchRequest]
                                                                               managedObjectContext:[self uiContext]
                                                                                 sectionNameKeyPath:@"session.name"
                                                                                          cacheName:nil];
    }
    
    return self;
}

- (void)reloadData {
    [self.sessionsFetchedResultsController performFetch:nil];
}

- (void)registerCellsForTableView:(UITableView *)tableView {
    [tableView registerNib:[UINib nibWithNibName:@"TEDTalkTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kTalkCellReuseIdentifier];
}

#pragma mark - UITableViewDataSource -
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TEDTalkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTalkCellReuseIdentifier];
    
    TEDTalk *talk = [_sessionsFetchedResultsController objectAtIndexPath:indexPath];
    [cell.talkNameLabel setText:talk.name];
    [cell.talkSpeakerName setText:talk.speaker.fullName];
    
    // Perform the asynchronous task on the background thread-
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSString *ImageURL = talk.imageURL;
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
        
        // Perform the task on the main thread using the main queue-
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // Perform the UI update in this block, like showing image.
            
            cell.talkImageView.image = [UIImage imageWithData:imageData];
            
        });
        
    });
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[self.sessionsFetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.sessionsFetchedResultsController sections] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [[[self.sessionsFetchedResultsController sections] objectAtIndex:section] name];
}

#pragma mark - Core Data -
- (NSFetchRequest *)createSessionsFetchRequest {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([TEDTalk class]) inManagedObjectContext:[self uiContext]];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    return fetchRequest;
}


#pragma mark - Convenience -
- (NSManagedObjectContext *)uiContext {
    return [[TEDCoreDataManager sharedManager] uiContext];
}

@end
