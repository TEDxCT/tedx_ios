//
//  TEDTalkViewController.h
//  TEDxCT
//
//  Created by Daniel Galasko on 4/2/14.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TEDTalkViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *talkName;
@property (strong, nonatomic) IBOutlet UILabel *genre;
@property (strong, nonatomic) IBOutlet UIImageView *talkImage;
@property (strong, nonatomic) IBOutlet UITextView *talkDescription;
@property (strong, nonatomic) IBOutlet UIButton *speakerName;

-(IBAction)speakerNamePressed;

@end
