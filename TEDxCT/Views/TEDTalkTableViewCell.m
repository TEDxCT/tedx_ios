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
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews {
    
//    CGRect newCellSubViewsFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//    CGRect newCellViewFrame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
//    
//    self.contentView.frame = self.contentView.bounds = self.backgroundView.frame = self.accessoryView.frame = newCellSubViewsFrame;
//    self.frame = newCellViewFrame;
//    
//    [super layoutSubviews];
}

@end
