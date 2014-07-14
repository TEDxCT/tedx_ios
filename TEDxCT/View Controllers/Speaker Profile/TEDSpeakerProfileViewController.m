//
//  TEDSpeakerProfileViewController.m
//  TEDxCT
//
//  Created by Carla G on 2014/04/14.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import "TEDSpeakerProfileViewController.h"

#import "TEDSpeaker.h"
#import "TEDSpeakerProfileDataSource.h"
#import "TEDSpeakerProfileNameAndPhotoTableViewCell.h"
#import "TEDSpeakerProfileDescriptionTableViewCell.h"
#import "TEDSpeakerProfileContactDetailTableViewCell.h"
@interface TEDSpeakerProfileViewController ()
@property (strong,nonatomic,readonly) TEDSpeaker *speaker;

@property (strong,nonatomic) TEDSpeakerProfileDataSource *profileDataSource;
@end

@implementation TEDSpeakerProfileViewController

- (instancetype)initWithSpeaker:(TEDSpeaker *)speaker {
    if (self = [super init]) {
        _speaker = speaker;
        _profileDataSource = [[TEDSpeakerProfileDataSource alloc] initWithSpeaker:speaker];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.allowsSelection = NO;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TEDSpeakerProfileNameAndPhotoTableViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"nameAndPhoto"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TEDSpeakerProfileDescriptionTableViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"description"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TEDSpeakerProfileContactDetailTableViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"contactDetail"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.profileDataSource reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TEDSpeakerProfileDataType dataType = [self.profileDataSource dataTypeForItemIndexPath:indexPath];
    //TODO: height needs to be dynamic
    switch (dataType) {
        case TEDSpeakerProfileDataTypeNameAndPhoto:
            return 200.f;
        case TEDSpeakerProfileDataTypeDescription:
            //need height of text
            return 200.f;
            break;
        case TEDSpeakerProfileDataTypeContactDetails:
            return 100.f;
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.profileDataSource numberOfItems];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TEDSpeakerProfileDataType dataType = [self.profileDataSource dataTypeForItemIndexPath:indexPath];
    UITableViewCell *cell;
    switch (dataType) {
        case TEDSpeakerProfileDataTypeNameAndPhoto:{
            TEDSpeakerProfileNameAndPhotoTableViewCell *photoAndNameCell = [tableView dequeueReusableCellWithIdentifier:@"nameAndPhoto" forIndexPath:indexPath];
            TEDSpeakerProfileDataNameAndPhoto *info = [self.profileDataSource dataForItemWithType:dataType atIndexPath:indexPath];
            [photoAndNameCell.nameLabel setText:info.speakerName];
            if ([[NSFileManager defaultManager] fileExistsAtPath:info.imageLocalPath]) {
                [photoAndNameCell.speakerImageView setImage:[UIImage imageWithContentsOfFile:info.imageLocalPath]];
            } else {
                [[[NSURLSession sharedSession] downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.speaker.imageURL]]
                                                     completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                                                         if (location) {
                                                             [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:info.imageLocalPath] error:nil];
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 id cell = [tableView cellForRowAtIndexPath:indexPath];
                                                                 if ([cell isKindOfClass:[TEDSpeakerProfileNameAndPhotoTableViewCell class]]) {
                                                                     [((TEDSpeakerProfileNameAndPhotoTableViewCell *)cell).speakerImageView setImage:[UIImage imageWithContentsOfFile:info.imageLocalPath]];
                                                                 }
                                                             });
                                                         }
                                                     }] resume];
                
            }
            cell = photoAndNameCell;
        }
            break;
        case TEDSpeakerProfileDataTypeDescription:{
            TEDSpeakerProfileDescriptionTableViewCell *descriptionCell = [tableView dequeueReusableCellWithIdentifier:@"description" forIndexPath:indexPath];
            cell = descriptionCell;
            TEDSpeakerProfileDataDescription *desc = [self.profileDataSource dataForItemWithType:dataType atIndexPath:indexPath];
            [descriptionCell.descriptionTextView setText:desc.descriptionText];
        }
            break;
        case TEDSpeakerProfileDataTypeContactDetails:{
            TEDSpeakerProfileContactDetailTableViewCell *contactCell = [tableView dequeueReusableCellWithIdentifier:@"contactDetail" forIndexPath:indexPath];
            cell = contactCell;
            TEDSpeakerProfileDataContactDetail *contactDetail = [self.profileDataSource dataForItemWithType:dataType atIndexPath:indexPath];
            [contactCell.typeLabel setText:contactDetail.name];
            [contactCell.valueTextView setText:contactDetail.value];
        }
            break;
    }
    return cell;
}

@end
