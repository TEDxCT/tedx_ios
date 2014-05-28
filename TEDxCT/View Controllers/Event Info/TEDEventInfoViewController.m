//
//  TEDEventInfoViewController.m
//  TEDxCT
//
//  Created by Carla G on 2014/04/14.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import "TEDEventInfoViewController.h"
#import <MapKit/MapKit.h>
#import "TEDEvent+Additions.h"
#import "TEDEvent.h"
#import "TEDCoreDataManager.h"
#import "TEDApplicationConfiguration.h"

@interface TEDEventInfoViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *eventName;
@property (weak, nonatomic) IBOutlet UITextView *eventDescription;
@property (weak, nonatomic) IBOutlet UITextView *eventLocation;
@property (weak, nonatomic) IBOutlet UILabel *eventStartTime;
@property (weak, nonatomic) IBOutlet UILabel *eventDate;

@property (strong, nonatomic) TEDEvent *event;

@end

@implementation TEDEventInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    NSFetchRequest *fetchRequest = [self createEventFetchRequest];
    _event = [[[self uiContext] executeFetchRequest:fetchRequest error:nil] firstObject];
    
    [super viewDidLoad];
    self.eventName.text = self.event.name;
    self.eventDescription.text = self.event.descriptionHTML;
    self.eventLocation.text = self.event.locationDescriptionHTML;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    self.eventStartTime.text = [formatter stringFromDate:self.event.startDate];
//    self.eventDate.text = self.event.startDate;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.title = @"Event Information";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)mapTapped:(id)sender {
    
    //give the user a choice of Apple or Google Maps
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Open in Maps" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Apple Maps",@"Google Maps", nil];
    [sheet showInView:self.view];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    //coordinates for the place we want to display
    CLLocationCoordinate2D baxterLocation = CLLocationCoordinate2DMake(-33.9572,18.4706);
    if (buttonIndex==0) {
        //Apple Maps, using the MKMapItem class
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:baxterLocation addressDictionary:nil];
        MKMapItem *item = [[MKMapItem alloc] initWithPlacemark:placemark];
        item.name = @"The Baxter Theatre";
        [item openInMapsWithLaunchOptions:nil];
    } else if (buttonIndex==1) {
        //Google Maps
        //construct a URL using the comgooglemaps schema
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"comgooglemaps://?center=%f,%f",baxterLocation.latitude,baxterLocation.longitude]];
        if (![[UIApplication sharedApplication] canOpenURL:url]) {
            NSLog(@"Google Maps app is not installed");
            //left as an exercise for the reader: open the Google Maps mobile website instead!
        } else {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

#pragma mark - CoreData - 
- (NSFetchRequest *)createEventFetchRequest {
    TEDApplicationConfiguration *config = [[TEDApplicationConfiguration alloc]init];
    NSManagedObjectContext *context = [[TEDCoreDataManager sharedManager] uiContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([TEDEvent class]) inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"name = %@", [config eventName]]];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"identifier"
                                                                   ascending:YES];
    
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    return fetchRequest;
}

#pragma mark - Convenience -
- (NSManagedObjectContext *)uiContext {
    return [[TEDCoreDataManager sharedManager] uiContext];
}


@end
