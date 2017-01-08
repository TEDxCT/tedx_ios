//
//  TEDSpeakersTableViewCell.m
//  TEDxCT
//
//  Created by Daniel Galasko on 4/17/14.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import "TEDSpeakersTableViewCell.h"

@implementation TEDSpeakersTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.speakerImageView.layer.cornerRadius = 40;
    self.speakerImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
