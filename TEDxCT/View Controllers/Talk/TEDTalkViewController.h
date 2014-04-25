//
//  TEDTalkViewController.h
//  TEDxCT
//
//  Created by Daniel Galasko on 4/2/14.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TEDTalk;

@interface TEDTalkViewController : UIViewController
- (instancetype)initWithTalk:(TEDTalk *)talk;
@end
