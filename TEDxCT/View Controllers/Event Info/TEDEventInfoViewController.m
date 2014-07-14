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
@property (weak, nonatomic) IBOutlet UIImageView *gradientView;
@property (weak, nonatomic) IBOutlet UIButton *mapButton;
@property (weak, nonatomic) IBOutlet UIButton *calendarButton;
@property (assign, nonatomic) CLLocationDegrees longitude;
@property (assign, nonatomic) CLLocationDegrees latitude;

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
    [self addGradientTintToImage];
    self.calendarButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.mapButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.calendarButton.layer.borderWidth = 1;
    self.mapButton.layer.borderWidth = 1;

    

    
    self.eventName.text = self.event.name;
    self.eventDescription.text = self.event.descriptionHTML;
    self.eventDescription.textColor = [UIColor whiteColor];
    
    self.eventLocation.text = self.event.locationDescriptionHTML;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    self.eventStartTime.text = [formatter stringFromDate:self.event.startDate];
//    self.eventDate.text = self.event.startDate;
    
    self.longitude = (CLLocationDegrees)[self.event.longitude doubleValue];
    self.latitude = (CLLocationDegrees)[self.event.latitude doubleValue];
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
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Navigate to Event" delegate:self
                                              cancelButtonTitle:@"Cancel"
                                         destructiveButtonTitle:nil
                                                otherButtonTitles:@"Apple Maps",@"Google Maps", nil];
    [sheet showInView:self.view];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    //coordinates for the place we want to display
    CLLocationCoordinate2D baxterLocation = CLLocationCoordinate2DMake(self.latitude,self.longitude);
    if (buttonIndex==0) {
        //Apple Maps, using the MKMapItem class
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:baxterLocation addressDictionary:nil];
        MKMapItem *item = [[MKMapItem alloc] initWithPlacemark:placemark];
        item.name = @"City Hall";
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

- (void)addGradientTintToImage {
    
    //Create a graphics context in the required size
    CGSize size = self.gradientView.frame.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //Create a colour space
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    //Create gradient
    UIColor *bottomColor = [[UIColor blackColor] colorWithAlphaComponent:1.0f];
    UIColor *topColour = [UIColor clearColor];
    NSArray *colours = [NSArray arrayWithObjects:(id)topColour.CGColor, (id)bottomColor.CGColor, nil];
    CGGradientRef gradient = CGGradientCreateWithColors (colorspace, (CFArrayRef)colours, NULL);
    
    //Fill the context with the gradient, assuming vertical
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(0, size.height), 0);
    
    //Create image from the context
    UIImage *gradientImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //Release gradent, colours space and context
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorspace);
    UIGraphicsEndImageContext();
    
    self.gradientView.image = gradientImage;
    
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
