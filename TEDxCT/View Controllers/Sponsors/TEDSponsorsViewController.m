//
//  TEDSponsorsViewController.m
//  TEDxCT
//
//  Created by Carla G on 2014/04/14.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import "TEDSponsorsViewController.h"

#import "TEDImageDownloader.h"
#import "TEDSponsorsDataSource.h"
#import "TEDCoreDataManager.h"
#import "TEDSponsor.h"
#import "TEDStorageService.h"
#import "TEDSponsorsTableViewCell.h"

NSString *const kSponsorCellReuseIdentifier = @"sponsorCell";

@interface TEDSponsorsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *sponsorsTableView;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) TEDImageDownloader *imageDownloader;

@end

@implementation TEDSponsorsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _imageDownloader = [[TEDImageDownloader alloc] init];

        _fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:[self createSponsorsFetchRequest]
                                                                               managedObjectContext:[self uiContext]
                                                                                 sectionNameKeyPath:nil
                                                                                          cacheName:nil];
    }
    return self;
}

- (void)reloadData {
    [self.fetchedResultsController performFetch:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.title = @"Sponsors";
    

    
    [self reloadData];
    [self.sponsorsTableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.sponsorsTableView setDataSource:self];
    [self.sponsorsTableView setDelegate:self];
    [self.sponsorsTableView registerNib:[UINib nibWithNibName:@"TEDSponsorsTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kSponsorCellReuseIdentifier];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Datasource -
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TEDSponsorsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSponsorCellReuseIdentifier];
    TEDSponsor *sponsor = [self sponsorForItemAtIndexPath:indexPath];
    cell.sponsorURL = sponsor.websiteURL;
    
    NSString *ImageURL = sponsor.imageURL;
    NSString *localPath = [TEDStorageService pathForImageWithURL:ImageURL eventName:@"TED" createIfNeeded:YES];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:localPath]) {
        [cell.sponsorImageView setImage:[UIImage imageWithContentsOfFile:[TEDStorageService pathForImageWithURL:ImageURL eventName:@"TED" createIfNeeded:YES]]];
    } else {
        [self.imageDownloader downloadImageWithURL:ImageURL forEventName:@"TED" completionHandler:^(UIImage *image, NSError *error) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [[(TEDSponsorsTableViewCell *)[tableView cellForRowAtIndexPath:indexPath] sponsorImageView] setImage:image];

            }];
        }];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    TEDSponsor *sponsor = [self sponsorForItemAtIndexPath:indexPath];
    NSString *websiteURL;
    if (sponsor.websiteURL){
        websiteURL = sponsor.websiteURL;
    } else {
        websiteURL =@"http://www.google.com";
    }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:websiteURL]];
}

#pragma mark - Table View Datasource -
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self numberOfSponsors];
}

- (NSFetchRequest *)createSponsorsFetchRequest {
    TEDSponsorsDataSource *datasource = [[TEDSponsorsDataSource alloc] init];
    return [datasource createSponsorsFetchRequest];

}

#pragma mark - Convenience -
- (NSManagedObjectContext *)uiContext {
    return [[TEDCoreDataManager sharedManager] uiContext];
}

- (TEDSponsor *)sponsorForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.fetchedResultsController objectAtIndexPath:indexPath];
}

- (NSInteger)numberOfSponsors {
    return [[self.fetchedResultsController fetchedObjects] count];
}
@end
