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
        UINavigationController *agNav = [[UINavigationController alloc] initWithRootViewController:agendaViewController];
        agNav.tabBarItem.image = [UIImage imageNamed:@"schedule.png"];
        agNav.tabBarItem.selectedImage = [UIImage imageNamed:@"scheduleon.png"];

        
        TEDSpeakersViewController *speakersViewController = [[TEDSpeakersViewController alloc]init];
        speakersViewController.title = @"Speakers";
        UINavigationController *spNav = [[UINavigationController alloc] initWithRootViewController:speakersViewController];
        spNav.tabBarItem.image = [UIImage imageNamed:@"speakers.png"];
        spNav.tabBarItem.selectedImage = [UIImage imageNamed:@"speakerson.png"];
        
        TEDEventInfoViewController *eventViewController = [[TEDEventInfoViewController alloc] init];
        eventViewController.title = @"Info";
        eventViewController.tabBarItem.image = [UIImage imageNamed:@"information.png"];
        eventViewController.tabBarItem.selectedImage =[UIImage imageNamed:@"informationon.png"];

        
        TEDMoreInfoViewController *moreInfoController = [[TEDMoreInfoViewController alloc]init];
        moreInfoController.title = @"More";
        UINavigationController *moreNav = [[UINavigationController alloc] initWithRootViewController:moreInfoController];
        moreNav.tabBarItem.image = [UIImage imageNamed:@"moreInfo.png"];
        moreNav.tabBarItem.selectedImage =[UIImage imageNamed:@"moreInfoon.png"];
        
        self.viewControllers = @[agNav,spNav , eventViewController, moreNav];
        
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
