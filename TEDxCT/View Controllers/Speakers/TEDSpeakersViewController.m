//
//  TEDSpeakersViewController.m
//  TEDxCT
//
//  Created by Carla G on 2014/04/14.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import "TEDSpeakersViewController.h"

#import "TEDImageDownloader.h"
#import "TEDSpeaker.h"
#import "TEDSpeakerProfileViewController.h"
#import "TEDSpeakersDataSource.h"
#import "TEDSpeakersTableViewCell.h"
#import "TEDStorageService.h"

NSString *const kSpeakersCellReuseIdentifier = @"speakersCell";


@interface TEDSpeakersViewController ()<UISearchDisplayDelegate , UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *speakersTableView;
@property (strong, nonatomic) TEDSpeakersDataSource *speakersDataSource;
@property (strong, nonatomic) TEDImageDownloader *imageDownloader;
@property (strong,nonatomic) UISearchBar *searchBar;
@property (strong,nonatomic) UISearchDisplayController *searchController;
@end

@implementation TEDSpeakersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _imageDownloader = [[TEDImageDownloader alloc] init];
    self.speakersDataSource = [[TEDSpeakersDataSource alloc] init];
    [self registerReusableViewsWithTableView:self.speakersTableView];
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    searchBar.placeholder = @"Search Speakers";
    _searchBar = searchBar;
    self.tableView.tableHeaderView = searchBar;
    
    UISearchDisplayController *searchController = [[UISearchDisplayController alloc]initWithSearchBar:searchBar
                                                                                   contentsController:self];
    searchController.delegate = self;
    searchController.searchResultsDataSource = self;
    searchController.searchResultsDelegate = self;
    _searchController = searchController;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.speakersDataSource reloadData];
    self.speakersTableView.dataSource = self;
    self.speakersTableView.delegate = self;
    
    self.tabBarController.title = @"All Speakers";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleContentImporterCompleteNotification:) name:kContentImporterCompleteNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    self.speakersTableView.dataSource = nil;
    self.speakersTableView.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kContentImporterCompleteNotification object:nil];

    [super viewDidDisappear:animated];
}

- (void)registerReusableViewsWithTableView:(UITableView *)tableView {
    [tableView registerNib:[UINib nibWithNibName:@"TEDSpeakersTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kSpeakersCellReuseIdentifier];
}

#pragma mark - UITableViewDataSource -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.speakersDataSource numberOfSpeakers];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TEDSpeakersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSpeakersCellReuseIdentifier];
    
    TEDSpeaker *speaker = [self.speakersDataSource speakerForItemAtIndexPath:indexPath];
    [cell.speakerNameLabel setText:speaker.fullName];
    [cell.funkyTitle setText:speaker.funkyTitle];
    
    NSString *ImageURL = speaker.imageURL;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:ImageURL]) {
        [cell.speakerImageView setImage:[UIImage imageWithContentsOfFile:[TEDStorageService pathForImageWithURL:ImageURL eventName:@"TED" createIfNeeded:YES]]];
    } else {
        [self.imageDownloader downloadImageWithURL:ImageURL forEventName:@"TED" completionHandler:^(UIImage *image, NSError *error) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [[(TEDSpeakersTableViewCell *)[tableView cellForRowAtIndexPath:indexPath] speakerImageView] setImage:image];
            }];
        }];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate -
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TEDSpeaker *selectedSpeaker = [self.speakersDataSource speakerForItemAtIndexPath:indexPath];
    TEDSpeakerProfileViewController *pvc = [[TEDSpeakerProfileViewController alloc] initWithSpeaker:selectedSpeaker];
    [self.navigationController pushViewController:pvc animated:YES];
}

#pragma mark - Searching -
- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView {
    [self registerReusableViewsWithTableView:tableView];
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView {
    [self.speakersDataSource resetFilter];
    [self.speakersTableView reloadData];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    if (searchString.length > 0) {
        [self.speakersDataSource filterSpeakersListWithNamesContaining:searchString];
        return YES;
    }
    return NO;
}


#pragma mark - Notification Handlers -
- (void)handleContentImporterCompleteNotification:(NSNotification *)notification {
    [self.speakersDataSource reloadData];
    [self.speakersTableView reloadData];
}
@end
