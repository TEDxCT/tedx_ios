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


@interface TEDSpeakersViewController ()<UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *speakersTableView;
@property (strong, nonatomic) TEDSpeakersDataSource *speakersDataSource;
@property (strong, nonatomic) TEDImageDownloader *imageDownloader;
@end

@implementation TEDSpeakersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _imageDownloader = [[TEDImageDownloader alloc] init];
    self.speakersDataSource = [[TEDSpeakersDataSource alloc] init];
    [self.speakersTableView registerNib:[UINib nibWithNibName:@"TEDSpeakersTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kSpeakersCellReuseIdentifier];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TEDSpeaker *selectedSpeaker = [self.speakersDataSource speakerForItemAtIndexPath:indexPath];
    TEDSpeakerProfileViewController *pvc = [[TEDSpeakerProfileViewController alloc] initWithSpeaker:selectedSpeaker];
    [self.navigationController pushViewController:pvc animated:YES];
}

#pragma mark - Notification Handlers -
- (void)handleContentImporterCompleteNotification:(NSNotification *)notification {
    [self.speakersDataSource reloadData];
    [self.speakersTableView reloadData];
}
@end
