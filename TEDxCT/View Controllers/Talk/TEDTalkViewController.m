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

@end

@implementation TEDTalkViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

-(IBAction)speakerNamePressed{
    TEDSpeakerProfileViewController *newVC = [[TEDSpeakerProfileViewController alloc] init];
    [self.navigationController pushViewController:newVC animated:YES];
}

@end
