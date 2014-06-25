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
            [self.tabBarController.navigationController pushViewController:newVC animated:YES];
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
    return @[@"Sponsors", @"TEDxCapeTown Website", @"Organizers"];
}

@end
