//
//  TEDSpeakerProfileViewController.m
//  TEDxCT
//
//  Created by Carla G on 2014/04/14.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import "TEDSpeakerProfileViewController.h"

#import "TEDSpeaker.h"
#import "TEDStorageService.h"

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
    NSString *localURL = [TEDStorageService pathForImageWithURL:self.speaker.imageURL
                                                      eventName:@"TED"
                                                 createIfNeeded:YES];
    self.edgesForExtendedLayout = UIRectEdgeNone;

    if ([[NSFileManager defaultManager] fileExistsAtPath:localURL]) {
        [self.speakerImageView setImage:[UIImage imageWithContentsOfFile:localURL]];
    } else {
        __weak TEDSpeakerProfileViewController *weakSelf = self;
        [[[NSURLSession sharedSession] downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.speaker.imageURL]]
                                             completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                                                 [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:localURL] error:nil];
                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                     [weakSelf.speakerImageView setImage:[UIImage imageWithContentsOfFile:localURL]];
                                                 });
                                             }] resume];
    }
}

@end
