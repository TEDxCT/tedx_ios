//
//  TEDSpeakerProfileNameAndPhotoTableViewCell.m
//  TEDxCT
//
//  Created by Daniel Galasko on 7/3/14.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import "TEDSpeakerProfileNameAndPhotoTableViewCell.h"

@implementation TEDSpeakerProfileNameAndPhotoTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
    self.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
