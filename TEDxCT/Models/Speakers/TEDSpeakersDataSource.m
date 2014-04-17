//
//  TEDSpeakersDataSource.m
//  TEDxCT
//
//  Created by Daniel Galasko on 4/17/14.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import "TEDSpeakersDataSource.h"
#import "TEDSpeakersTableViewCell.h"
#import "TEDSpeaker.h"
#import "TEDCoreDataManager.h"

NSString *const kSpeakersCellReuseIdentifier = @"speakersCell";

@interface TEDSpeakersDataSource ()

@property (strong, nonatomic) NSFetchedResultsController *speakersFetchedResultsController;

@end

@implementation TEDSpeakersDataSource

- (id)init {
    self = [super init];
    if (self) {
        _speakersFetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:[self createSpeakersFetchRequest]
                                                                               managedObjectContext:[[TEDCoreDataManager sharedManager] uiContext]
                                                                                 sectionNameKeyPath:nil
                                                                                          cacheName:nil];
        
        [_speakersFetchedResultsController performFetch:nil];
        
    }
    
    return self;
}

- (void)registerCellsForTableView:(UITableView *)tableView {
    [tableView registerNib:[UINib nibWithNibName:@"TEDSpeakersTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kSpeakersCellReuseIdentifier];
    
}

#pragma mark - UITableViewDataSource -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_speakersFetchedResultsController fetchedObjects] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TEDSpeakersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSpeakersCellReuseIdentifier];
    
    TEDSpeaker *speaker = [_speakersFetchedResultsController objectAtIndexPath:indexPath];
    [cell.speakerNameLabel setText:speaker.fullName];
    // Perform the asynchronous task on the background thread-
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        // Perform the asynchronous task in this block like loading data from server
        
        NSString *ImageURL = speaker.imageURL;
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
        
        
        // Perform the task on the main thread using the main queue-
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            // Perform the UI update in this block, like showing image.
            
            cell.speakerImageView.image = [UIImage imageWithData:imageData];
            
        });
        
    });
    
    return cell;
}

- (NSFetchRequest *)createSpeakersFetchRequest {
    NSManagedObjectContext *context = [[TEDCoreDataManager sharedManager] uiContext];

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([TEDSpeaker class]) inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:nil];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"fullName"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    return fetchRequest;
}

@end
