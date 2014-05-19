//
//  TEDTalkViewController.m
//  TEDxCT
//
//  Created by Daniel Galasko on 4/2/14.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import "TEDTalkViewController.h"
#import "TEDSpeakerProfileViewController.h"
#import "TEDTalk.h"
#import "TEDSpeaker.h"


@interface TEDTalkViewController ()
@property (strong,nonatomic,readonly) TEDTalk *talk;
@property (weak, nonatomic) IBOutlet UILabel *talkName;
@property (weak, nonatomic) IBOutlet UILabel *genre;
@property (weak, nonatomic) IBOutlet UIImageView *talkImage;
@property (weak, nonatomic) IBOutlet UITextView *talkDescription;
@property (weak, nonatomic) IBOutlet UIButton *speakerName;
@end

@implementation TEDTalkViewController

- (instancetype)initWithTalk:(TEDTalk *)talk {
    if (self = [super init]) {
        _talk = talk;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.talkName setText:_talk.name];
    [self.talkDescription setText:_talk.descriptionHTML];
    [self.speakerName setTitle:_talk.speaker.fullName forState:UIControlStateNormal];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSString *ImageURL = _talk.imageURL;
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
        
        // Perform the task on the main thread using the main queue-
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // Perform the UI update in this block, like showing image.
            
            _talkImage.image = [UIImage imageWithData:imageData];
            
        });
        
    });

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)speakerNamePressed:(UIButton *)speakerNameButton {
    //TODO: Fetch the speaker from the button
    TEDSpeakerProfileViewController *newVC = [[TEDSpeakerProfileViewController alloc] initWithSpeaker:_talk.speaker];
    [self.navigationController pushViewController:newVC animated:YES];
}

@end
