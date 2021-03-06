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
#import "TEDSession.h"
#import "TEDSpeaker.h"
#import "TEDCoreDataManager.h"
#import "TEDImageDownloader.h"
#import "TEDStorageService.h"

#define AGENDA_LOGGER 0

#if AGENDA_LOGGER == 1
#	define ALog(fmt, ...) NSLog((fmt), ##__VA_ARGS__);
#else
#	define ALog(...)
#endif

NSString *const kTalkCellReuseIdentifier = @"talkCell";

@interface TEDAgendaDataSource ()
@property (strong, nonatomic) NSFetchedResultsController *talksFetchedResultsController;
@property (strong,nonatomic) TEDImageDownloader *imageDownloader;
@end

@implementation TEDAgendaDataSource

- (id)init {
    self = [super init];
    if (self) {
        _talksFetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:[self createTalksFetchRequest]
                                                                               managedObjectContext:[self uiContext]
                                                                                 sectionNameKeyPath:@"session.startTime"
                                                                                          cacheName:nil];
        _imageDownloader = [[TEDImageDownloader alloc] init];
    }
    
    return self;
}

- (void)resetFilter {
    self.talksFetchedResultsController.fetchRequest.predicate = [self createTalksFetchRequest].predicate;
    [self.talksFetchedResultsController performFetch:nil];
}

- (void)filterTalksWithSearchString:(NSString *)searchString {
    self.talksFetchedResultsController.fetchRequest.predicate = [NSPredicate predicateWithFormat:@"name contains[c] %@ || speaker.fullName contains[c] %@",searchString,searchString];
    [self.talksFetchedResultsController performFetch:nil];
}

- (void)reloadData {
    [self.talksFetchedResultsController performFetch:nil];
}

- (void)registerCellsForTableView:(UITableView *)tableView {
    [tableView registerNib:[UINib nibWithNibName:@"TEDTalkTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kTalkCellReuseIdentifier];
}

- (TEDTalk *)talkForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.talksFetchedResultsController objectAtIndexPath:indexPath];
}

#pragma mark - UITableViewDataSource -
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TEDTalkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTalkCellReuseIdentifier];
    
    TEDTalk *talk = [_talksFetchedResultsController objectAtIndexPath:indexPath];
    [cell.talkNameLabel setText:talk.name];
    
    if (cell.talkSpeakerName) {
        [cell.talkSpeakerName setText:talk.speaker.fullName];
    }
    
    [cell.genre setText:talk.genre];
    
    NSString *imageURL = talk.imageURL;
    NSString *downloadPath =[TEDStorageService pathForImageWithURL:imageURL eventName:@"TED" createIfNeeded:NO];
    ALog(@"%s GET IMAGE WITH URL: %@", __PRETTY_FUNCTION__, downloadPath);

    if ([[NSFileManager defaultManager] fileExistsAtPath:downloadPath]) {
        ALog(@"%s IMAGE EXISTS AT: %@", __PRETTY_FUNCTION__, downloadPath);

        [cell.talkImageView setImage:[UIImage imageWithContentsOfFile:downloadPath]];
    } else {
        [self.imageDownloader downloadImageWithURL:imageURL forEventName:@"TED" completionHandler:^(UIImage *image, NSError *error) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [[(TEDTalkTableViewCell *)[tableView cellForRowAtIndexPath:indexPath] talkImageView] setImage:image];
            }];
        }];
    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[self.talksFetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.talksFetchedResultsController sections] count];
}

- (TEDSession *)sessionForSection:(NSInteger)section {
    TEDTalk *talk = [self.talksFetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    return talk.session;
}

- (NSInteger)indexForSessionWithName:(NSString *)sessionName {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([TEDSession class]) inManagedObjectContext:[self uiContext]];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptorIdentifier = [[NSSortDescriptor alloc] initWithKey:@"startTime"
                                                                             ascending:YES];
    
    fetchRequest.propertiesToFetch = @[@"name"];
    fetchRequest.resultType = NSDictionaryResultType;
    
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptorIdentifier, nil]];
    
    NSArray *sessions = [[self uiContext] executeFetchRequest:fetchRequest error:nil];
    
    NSInteger index=0;
    
    for(NSDictionary *session in sessions)
    {
        if([session[@"name"] isEqualToString: sessionName])
        {
            return index;
        }
        index++;
    }
    
    return -1;
}

#pragma mark - Core Data -
- (NSFetchRequest *)createTalksFetchRequest {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([TEDTalk class]) inManagedObjectContext:[self uiContext]];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptorIdentifier = [[NSSortDescriptor alloc] initWithKey:@"session.startTime"
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
