//
//  TEDLaunchViewController.m
//  TEDxCT
//
//  Created by Daniel Galasko on 3/31/14.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import "TEDLaunchViewController.h"
#import "TEDCoreDataManager.h"

@interface TEDLaunchViewController ()

@end

@implementation TEDLaunchViewController

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
    [TEDCoreDataManager initialiseSharedManager];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
