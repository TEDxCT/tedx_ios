//
//  TEDSpeakerProfileViewController.h
//  TEDxCT
//
//  Created by Carla G on 2014/04/14.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TEDSpeaker;

@interface TEDSpeakerProfileViewController : UIViewController
- (instancetype)initWithSpeaker:(TEDSpeaker *)speaker;
@end
