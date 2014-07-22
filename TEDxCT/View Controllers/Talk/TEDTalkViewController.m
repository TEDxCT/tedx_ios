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
#import "TEDStorageService.h"

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
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.talkName setText:_talk.name];
    [self.genre setText:_talk.genre];
    [self.talkDescription setText:_talk.descriptionHTML];
    [self.speakerName setTitle:_talk.speaker.fullName forState:UIControlStateNormal];
    
    NSString *imageLocalPath = [TEDStorageService pathForImageWithURL:_talk.imageURL
                                                               eventName:@"TED"
                                                          createIfNeeded:YES];
    
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:imageLocalPath]) {
        [self.talkImage setImage:[UIImage imageWithContentsOfFile:imageLocalPath]];
    } else {
        [[[NSURLSession sharedSession] downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.talk.imageURL]]
                                             completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                                                 if (location) {
                                                     [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:imageLocalPath] error:nil];
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         [self.talkImage setImage:[UIImage imageWithContentsOfFile:imageLocalPath]];
                                                         
                            
                                                     });
                                                 }
                                             }] resume];
        
    }
    
    
    _talkImage.layer.cornerRadius = CGRectGetWidth(_talkImage.frame)/2;
    _talkImage.layer.masksToBounds = YES;
    
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
