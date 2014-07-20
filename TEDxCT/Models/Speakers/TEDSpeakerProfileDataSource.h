//
//  TEDSpeakerProfileDataSource.h
//  TEDxCT
//
//  Created by Daniel Galasko on 7/3/14.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TEDSpeakerProfileDataType) {
    TEDSpeakerProfileDataTypeNameAndPhoto,
    TEDSpeakerProfileDataTypeDescription,
    TEDSpeakerProfileDataTypeContactDetails
};

@class TEDSpeaker;

@interface TEDSpeakerProfileDataSource : NSObject<UITableViewDataSource>
- (instancetype)initWithSpeaker:(TEDSpeaker *)speaker;
- (void)reloadData;
- (void)registerReusableCellsForTableView:(UITableView *)tableView;
- (NSInteger)numberOfItems;
- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView;
@end



@interface TEDSpeakerProfileDataNameAndPhoto : NSObject
@property (strong,nonatomic) NSString *imageRemoteURL;
@property (strong,nonatomic) NSString *imageLocalPath;
@property (strong,nonatomic) NSString *speakerName;
@property (strong,nonatomic) NSString *genre;
@property (strong,nonatomic) NSString *talkName;
@end

@interface TEDSpeakerProfileDataDescription : NSObject
@property (strong,nonatomic) NSString *descriptionText;
@end

@interface TEDSpeakerProfileDataContactDetail : NSObject
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *value;
@end