//
//  TEDSpeakersTableViewCell.h
//  TEDxCT
//
//  Created by Daniel Galasko on 4/17/14.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TEDSpeakersTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *speakerImageView;
@property (weak, nonatomic) IBOutlet UILabel *speakerNameLabel;

@end
