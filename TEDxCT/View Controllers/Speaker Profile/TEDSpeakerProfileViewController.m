//
//  TEDSpeakerProfileViewController.m
//  TEDxCT
//
//  Created by Carla G on 2014/04/14.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import "TEDSpeakerProfileViewController.h"

#import "TEDSpeaker.h"

@interface TEDSpeakerProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *speakerImageView;
@property (weak, nonatomic) IBOutlet UILabel *speakerNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *fullDescriptionTextView;
@property (strong,nonatomic,readonly) TEDSpeaker *speaker;
@end

@implementation TEDSpeakerProfileViewController

- (instancetype)initWithSpeaker:(TEDSpeaker *)speaker {
    if (self = [super init]) {
        _speaker = speaker;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.speakerNameLabel.text = self.speaker.fullName;
    [self.fullDescriptionTextView setText:self.speaker.descriptionHTML];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
