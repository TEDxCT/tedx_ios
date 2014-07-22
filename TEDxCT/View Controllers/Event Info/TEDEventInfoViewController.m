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
#import "UIImage+ImageEffects.h"

@interface TEDEventInfoViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *eventName;
@property (weak, nonatomic) IBOutlet UITextView *eventDescription;
@property (weak, nonatomic) IBOutlet UIButton *mapButton;
@property (weak, nonatomic) IBOutlet UIButton *calendarButton;
@property (assign, nonatomic) CLLocationDegrees longitude;
@property (assign, nonatomic) CLLocationDegrees latitude;
@property (weak,nonatomic) IBOutlet UIImageView *gradientImage;
@property (strong, nonatomic) TEDEvent *event;
@property (weak, nonatomic) IBOutlet UIButton *eventDateButtonWithDate;
@property (weak, nonatomic) IBOutlet UIImageView *blurImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *eventNameLabelVerticalSpaceConstraint;
@end

@implementation TEDEventInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSFetchRequest *fetchRequest = [self createEventFetchRequest];
    _event = [[[self uiContext] executeFetchRequest:fetchRequest error:nil] firstObject];
        
    self.eventName.text = self.event.name;
    [self.eventName sizeToFit];
    self.eventDescription.text = self.event.descriptionHTML;
//    
//    self.eventLocation.text = self.event.locationDescriptionHTML;
//    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"HH:mm"];
//    self.eventStartTime.text = [formatter stringFromDate:self.event.startDate];
//    self.eventDate.text = self.event.startDate;
    
    self.longitude = (CLLocationDegrees)[self.event.longitude doubleValue];
    self.latitude = (CLLocationDegrees)[self.event.latitude doubleValue];
    
//    NSMutableAttributedString *commentString = [self.eventDateButtonWithDate.titleLabel.attributedText mutableCopy];
//    
//    [commentString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [commentString length])];
//    
//    [self.eventDateButtonWithDate setAttributedTitle:commentString forState:UIControlStateNormal];
    UIColor *globalTint = [[[UIApplication sharedApplication] delegate] window].tintColor;

//    self.calendarButton.backgroundColor = globalTint;
//    self.calendarButton.alpha = 0.6f;
    [self addBorderToButton:self.calendarButton color:globalTint];
    [self addBorderToButton:self.mapButton color:globalTint];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.blurImageView.image) {
        self.blurImageView.image = [self.backgroundImage.image applyBlurWithRadius:30.f tintColor:nil saturationDeltaFactor:0.5f maskImage:nil];
        self.blurImageView.alpha = 0.f;
        [self addGradientTintToImage];
    }
    self.eventNameLabelVerticalSpaceConstraint.constant = CGRectGetHeight(self.view.bounds) - [self.bottomLayoutGuide length]*3.f;
    
    self.tabBarController.title = @"Event Information";
//    self.blurImageView.image = [self.backgroundImage.image applyDarkEffect];
}

- (IBAction)mapTapped:(id)sender {
    
    //give the user a choice of Apple or Google Maps
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Navigate to Event"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                         destructiveButtonTitle:nil
                                                otherButtonTitles:@"Apple Maps", nil];
    [sheet showInView:self.view];
    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    //coordinates for the place we want to display
    if (buttonIndex == 0) {
        CLLocationCoordinate2D baxterLocation = CLLocationCoordinate2DMake(self.latitude,self.longitude);
        
        //Apple Maps, using the MKMapItem class
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:baxterLocation addressDictionary:nil];
        MKMapItem *item = [[MKMapItem alloc] initWithPlacemark:placemark];
        item.name = @"City Hall";
        [item openInMapsWithLaunchOptions:nil];
    }
}

- (void)addGradientTintToImage {
    
    //Create a graphics context in the required size
    CGSize size = self.view.frame.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //Create a colour space
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    //Create gradient
    UIColor *bottomColor = [[UIColor blackColor] colorWithAlphaComponent:0.8f];
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
    
    self.gradientImage.image = gradientImage;
    self.gradientImage.alpha = 1.f;
    
}

#pragma mark - ScrollView Delegate -
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat y = scrollView.contentOffset.y;
    if (y > 0) {
        CGFloat percentage = y/CGRectGetHeight(scrollView.bounds);
        self.blurImageView.alpha = MIN(1.f,4.5f*percentage);
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

- (void)addBorderToButton:(UIButton *)button color:(UIColor *)color {
    button.layer.cornerRadius = 4.f;
    button.layer.borderWidth = 1.f;
    button.layer.borderColor = color.CGColor;
    button.titleLabel.textColor = color;
}


@end
