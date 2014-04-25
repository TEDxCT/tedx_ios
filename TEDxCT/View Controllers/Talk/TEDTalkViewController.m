//
//  TEDTalkViewController.m
//  TEDxCT
//
//  Created by Daniel Galasko on 4/2/14.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import "TEDTalkViewController.h"
#import "TEDSpeakerProfileViewController.h"

@interface TEDTalkViewController ()
@property (weak, nonatomic) IBOutlet UILabel *talkName;
@property (weak, nonatomic) IBOutlet UILabel *genre;
@property (weak, nonatomic) IBOutlet UIImageView *talkImage;
@property (weak, nonatomic) IBOutlet UITextView *talkDescription;
@property (weak, nonatomic) IBOutlet UIButton *speakerName;
@end

@implementation TEDTalkViewController

- (instancetype)initWithTalk:(TEDTalk *)talk {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)speakerNamePressed:(UIButton *)speakerNameButton {
    //TODO: Fetch the speaker from the button
    TEDSpeakerProfileViewController *newVC = [[TEDSpeakerProfileViewController alloc] initWithSpeaker:nil];
    [self.navigationController pushViewController:newVC animated:YES];
}

@end
