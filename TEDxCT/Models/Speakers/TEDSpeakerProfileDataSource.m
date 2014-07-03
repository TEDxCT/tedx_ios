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

- (NSInteger)numberOfItems {
    return [self.speakerProfileArray count];
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

