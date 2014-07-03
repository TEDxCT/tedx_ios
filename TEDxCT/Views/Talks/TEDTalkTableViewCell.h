//
//  TEDTalkTableViewCell.h
//  TEDxCT
//
//  Created by Carla G on 2014/04/16.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TEDTalkTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *talkImageView;
@property (weak, nonatomic) IBOutlet UILabel *talkNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *talkSpeakerName;
@property (weak, nonatomic) IBOutlet UILabel *genre;


@end
