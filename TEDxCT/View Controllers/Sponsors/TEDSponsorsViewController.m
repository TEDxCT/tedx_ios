//
//  TEDSponsorsViewController.m
//  TEDxCT
//
//  Created by Carla G on 2014/04/14.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import "TEDSponsorsViewController.h"
#import "TEDSponsorsDataSource.h"
#import "TEDCoreDataManager.h"
#import "TEDSponsor.h"

NSString *const kSponsorCellReuseIdentifier = @"sponsorCell";

@interface TEDSponsorsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *sponsorsTableView;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation TEDSponsorsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
    [self.sponsorsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kSponsorCellReuseIdentifier];
    
    [self.sponsorsTableView setDataSource:self];
    [self.sponsorsTableView setDelegate:self];
    
    [self reloadData];
    [self.sponsorsTableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Delegate -
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSponsorCellReuseIdentifier];
    
    TEDSponsor *sponsor = [self sponsorForItemAtIndexPath:indexPath];
    
    cell.textLabel.text = sponsor.name;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == 0) {
        TEDSponsorsViewController *newVC = [[TEDSponsorsViewController alloc]init];
        [self.tabBarController.navigationController pushViewController:newVC animated:YES];
    }
    
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
