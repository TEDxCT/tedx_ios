//
//  TEDSpeakerProfileDataSource.m
//  TEDxCT
//
//  Created by Daniel Galasko on 7/3/14.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import "TEDSpeakerProfileDataSource.h"
#import "TEDSpeaker+Additions.h"
#import "TEDStorageService.h"
#import "TEDSpeakerProfileNameAndPhotoTableViewCell.h"
#import "TEDSpeakerProfileDescriptionTableViewCell.h"
#import "TEDSpeakerProfileContactDetailTableViewCell.h"

@interface TEDSpeakerProfileDataSource()
@property (strong,nonatomic,readonly) TEDSpeaker *speaker;
@property (strong,nonatomic) NSMutableArray *speakerProfileArray;
@end
@implementation TEDSpeakerProfileDataSource

- (instancetype)initWithSpeaker:(TEDSpeaker *)speaker {
    if (self = [super init]) {
        _speaker = speaker;
        _speakerProfileArray = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)registerReusableCellsForTableView:(UITableView *)tableView {
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TEDSpeakerProfileNameAndPhotoTableViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([TEDSpeakerProfileNameAndPhotoTableViewCell class])];
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TEDSpeakerProfileDescriptionTableViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([TEDSpeakerProfileDescriptionTableViewCell class])];
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TEDSpeakerProfileContactDetailTableViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([TEDSpeakerProfileContactDetailTableViewCell class])];
}

- (void)reloadData {
    [self.speakerProfileArray removeAllObjects];
    
    TEDSpeakerProfileDataNameAndPhoto *nameAndPhoto = [[TEDSpeakerProfileDataNameAndPhoto alloc] init];
    nameAndPhoto.imageLocalPath = [TEDStorageService pathForImageWithURL:self.speaker.imageURL
                                                               eventName:@"TED"
                                                          createIfNeeded:YES];
    nameAndPhoto.speakerName = self.speaker.fullName;
    
    [self.speakerProfileArray addObject:nameAndPhoto];
    
    TEDSpeakerProfileDataDescription *description = [[TEDSpeakerProfileDataDescription alloc] init];
    description.descriptionText = self.speaker.descriptionHTML;

    [self.speakerProfileArray addObject:description];
    
    for (NSDictionary *dict in self.speaker.contactDetails) {
        TEDSpeakerProfileDataContactDetail *detail = [[TEDSpeakerProfileDataContactDetail alloc] init];
        detail.value = dict[@"value"];
        detail.name = dict[@"name"];
        [self.speakerProfileArray addObject:detail];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self numberOfItems];
}

- (NSInteger)numberOfItems {
    return [self.speakerProfileArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TEDSpeakerProfileDataType dataType = [self dataTypeForItemIndexPath:indexPath];
    UITableViewCell *cell;
    switch (dataType) {
        case TEDSpeakerProfileDataTypeNameAndPhoto:{
            TEDSpeakerProfileNameAndPhotoTableViewCell *photoAndNameCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TEDSpeakerProfileNameAndPhotoTableViewCell class]) forIndexPath:indexPath];
            TEDSpeakerProfileDataNameAndPhoto *info = [self dataForItemWithType:dataType atIndexPath:indexPath];
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
            TEDSpeakerProfileDescriptionTableViewCell *descriptionCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TEDSpeakerProfileDescriptionTableViewCell class]) forIndexPath:indexPath];
            cell = descriptionCell;
            TEDSpeakerProfileDataDescription *desc = [self dataForItemWithType:dataType atIndexPath:indexPath];
            [descriptionCell.descriptionTextView setText:desc.descriptionText];
        }
            break;
        case TEDSpeakerProfileDataTypeContactDetails:{
            TEDSpeakerProfileContactDetailTableViewCell *contactCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TEDSpeakerProfileContactDetailTableViewCell class]) forIndexPath:indexPath];
            cell = contactCell;
            TEDSpeakerProfileDataContactDetail *contactDetail = [self dataForItemWithType:dataType atIndexPath:indexPath];
            [contactCell.typeLabel setText:contactDetail.name];
            [contactCell.valueTextView setText:contactDetail.value];
        }
            break;
    }
    return cell;
}

- (TEDSpeakerProfileDataType)dataTypeForItemIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = [indexPath row];
    if (row == 0) {
        return TEDSpeakerProfileDataTypeNameAndPhoto;
    } else if(row == 1){
        return TEDSpeakerProfileDataTypeDescription;
    } else {
        return TEDSpeakerProfileDataTypeContactDetails;
    }
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView {
    
    TEDSpeakerProfileDataType dataType = [self dataTypeForItemIndexPath:indexPath];
    //TODO: height needs to be dynamic
    switch (dataType) {
        case TEDSpeakerProfileDataTypeNameAndPhoto:
            return 200.f;
        case TEDSpeakerProfileDataTypeDescription:{
            TEDSpeakerProfileDataDescription *desc = [self dataForItemWithType:dataType atIndexPath:indexPath];

            NSString *text = desc.descriptionText;
            CGFloat width = CGRectGetWidth(tableView.bounds) - 30.0f*2.f;
            UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
            NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text
                                                                                 attributes:@{NSFontAttributeName: font}];
            CGRect rect = [attributedText boundingRectWithSize:(CGSize){width, CGFLOAT_MAX}
                                                       options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                       context:nil];
            CGSize size = rect.size;
            
            //need height of text
            return MAX(ceilf(size.height),44.0f);
        }
            break;
        case TEDSpeakerProfileDataTypeContactDetails:
            return 100.f;
            break;
    }
}

- (id)dataForItemWithType:(TEDSpeakerProfileDataType)dataType atIndexPath:(NSIndexPath *)indexPath {
    return self.speakerProfileArray[[indexPath row]];
}

@end

@implementation TEDSpeakerProfileDataNameAndPhoto
@end
@implementation TEDSpeakerProfileDataDescription
@end
@implementation TEDSpeakerProfileDataContactDetail
@end

