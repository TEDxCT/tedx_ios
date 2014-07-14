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
#import "TEDImageDownloader.h"
#import "TEDStorageService.h"

NSString *const kTalkCellReuseIdentifier = @"talkCell";

@interface TEDAgendaDataSource ()
@property (strong, nonatomic) NSFetchedResultsController *sessionsFetchedResultsController;
@property (strong,nonatomic) TEDImageDownloader *imageDownloader;
@end

@implementation TEDAgendaDataSource

- (id)init {
    self = [super init];
    if (self) {
        _sessionsFetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:[self createSessionsFetchRequest]
                                                                               managedObjectContext:[self uiContext]
                                                                                 sectionNameKeyPath:@"session.name"
                                                                                          cacheName:nil];
        _imageDownloader = [[TEDImageDownloader alloc] init];
    }
    
    return self;
}

- (void)reloadData {
    [self.sessionsFetchedResultsController performFetch:nil];
}

- (void)registerCellsForTableView:(UITableView *)tableView {
    [tableView registerNib:[UINib nibWithNibName:@"TEDTalkTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kTalkCellReuseIdentifier];
}

- (TEDTalk *)talkForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.sessionsFetchedResultsController objectAtIndexPath:indexPath];
}

#pragma mark - UITableViewDataSource -
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TEDTalkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTalkCellReuseIdentifier];
    
    TEDTalk *talk = [_sessionsFetchedResultsController objectAtIndexPath:indexPath];
    [cell.talkNameLabel setText:talk.name];
    [cell.talkSpeakerName setText:talk.speaker.fullName];
    
    if (talk.genre.length == 0) {
        [cell.genre setText:@"No Genre"];
    }
    else{
        [cell.genre setText:talk.genre];
    }

    NSString *ImageURL = talk.imageURL;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:ImageURL]) {
        [cell.talkImageView setImage:[UIImage imageWithContentsOfFile:[TEDStorageService pathForImageWithURL:ImageURL eventName:@"TED" createIfNeeded:YES]]];
    } else {
        [self.imageDownloader downloadImageWithURL:ImageURL forEventName:@"TED" completionHandler:^(UIImage *image, NSError *error) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [[(TEDTalkTableViewCell *)[tableView cellForRowAtIndexPath:indexPath] talkImageView] setImage:image];
            }];
        }];
    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[self.sessionsFetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.sessionsFetchedResultsController sections] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [[[[self.sessionsFetchedResultsController sections] objectAtIndex:section] name] uppercaseString];
}

#pragma mark - Core Data -
- (NSFetchRequest *)createSessionsFetchRequest {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([TEDTalk class]) inManagedObjectContext:[self uiContext]];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptorIdentifier = [[NSSortDescriptor alloc] initWithKey:@"identifier"
                                                                   ascending:YES];
    
    NSSortDescriptor *sortDescriptorOrderInSession = [[NSSortDescriptor alloc] initWithKey:@"orderInSession"
                                                                   ascending:YES];
    
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptorIdentifier, sortDescriptorOrderInSession, nil]];
    
    return fetchRequest;
}


#pragma mark - Convenience -
- (NSManagedObjectContext *)uiContext {
    return [[TEDCoreDataManager sharedManager] uiContext];
}

@end
