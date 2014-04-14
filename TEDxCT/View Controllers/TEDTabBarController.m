//
//  TEDTabBarController.m
//  TEDxCT
//
//  Created by Carla G on 2014/04/02.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import "TEDTabBarController.h"
#import "TEDAgendaTableViewController.h"
#import "TEDEventInfoViewController.h"
#import "TEDMoreInfoViewController.h"
#import "TEDSpeakersViewController.h"

@interface TEDTabBarController ()
@property (strong, nonatomic) IBOutlet UITabBarItem *agendaItem;

@end

@implementation TEDTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        TEDAgendaTableViewController *agendaViewController = [[TEDAgendaTableViewController alloc]init];
        agendaViewController.title = @"Agenda";
        
        TEDSpeakersViewController *speakersViewController = [[TEDSpeakersViewController alloc]init];
        speakersViewController.title = @"Speakers";
        
        TEDEventInfoViewController *eventViewController = [[TEDEventInfoViewController alloc] init];
        eventViewController.title = @"Info";
        
        TEDMoreInfoViewController *moreInfoController = [[TEDMoreInfoViewController alloc]init];
        moreInfoController.title = @"More";
        
        self.viewControllers = @[agendaViewController, speakersViewController, eventViewController, moreInfoController];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
