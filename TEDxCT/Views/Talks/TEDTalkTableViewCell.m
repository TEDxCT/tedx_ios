//
//  TEDTalkTableViewCell.m
//  TEDxCT
//
//  Created by Carla G on 2014/04/16.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import "TEDTalkTableViewCell.h"

@implementation TEDTalkTableViewCell

- (void)awakeFromNib
{
    self.talkImageView.layer.cornerRadius = CGRectGetWidth(self.talkImageView.frame)/2;
    self.talkImageView.layer.masksToBounds = YES;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
