//
//  TEDMoreInfoViewController.m
//  TEDxCT
//
//  Created by Carla G on 2014/04/14.
//  Copyright (c) 2014 TEDxCapeTown. All rights reserved.
//

#import "TEDMoreInfoViewController.h"
#import "TEDSponsorsViewController.h"

NSString *const kInfoCellReuseIdentifier = @"infoCell";

@interface TEDMoreInfoViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *moreInfoTableView;
@property (strong, nonatomic) NSArray *infoTableRows;

@end

@implementation TEDMoreInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _infoTableRows = [self listOfInfoItems];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.title = @"More Information";
    [self.moreInfoTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kInfoCellReuseIdentifier];

    [self.moreInfoTableView setDataSource:self];
    [self.moreInfoTableView setDelegate:self];
    [self.moreInfoTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Delegate -
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kInfoCellReuseIdentifier];
    
    cell.textLabel.text = [self.infoTableRows objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if(indexPath.row == 0) {
            TEDSponsorsViewController *newVC = [[TEDSponsorsViewController alloc]init];
            [self.navigationController pushViewController:newVC animated:YES];
    } else if (indexPath.row == 1) {

            NSString *websiteURL = @"http://www.tedxcapetown.org";
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:websiteURL]];
        
    } else if (indexPath.row == 2) {
        NSString *url = @"https://www.youtube.com/playlist?list=PLsRNoUx8w3rMg_k2vZlx9n9hn1ARbcEHt";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];

    } else if (indexPath.row == 3) {
        NSString *url = @"https://www.youtube.com/watch?v=0A_-LHf58j0";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    } else if (indexPath.row == 4) {
        NSString *url = @"http://opendesignct.com/";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}

#pragma mark - Table View Datasource - 
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.infoTableRows count];
}

- (NSArray *)listOfInfoItems {
    return @[@"Sponsors", @"TEDxCapeTown Website", @"2013 Videos", @"2012 Videos", @"Open Design CT"];
}

@end
