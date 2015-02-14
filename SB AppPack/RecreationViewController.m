//
//  RecreationViewController.m
//  SB AppPack
//
//  Created by Richard Hartmann on 11/5/13.
//  Copyright (c) 2013 Richard Hartmann. All rights reserved.
//

#import "RecreationViewController.h"
#import "AppDelegate.h"
#import "CustomRecreationCell.h"
#import "RecreationClutterBubble.h"

@interface RecreationViewController ()
{
    NSMutableArray *arrayOfCellData;
    NSMutableArray *arrayOfCells;
}
@end

@implementation RecreationViewController
@synthesize sharedNetorkManager;
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
	// Do any additional setup after loading the view.
    
    [[self myTableView]setDataSource:self];
    [[self myTableView]setDelegate:self];
    
    arrayOfCellData = [[NSMutableArray alloc] init];
    
    if(sharedNetorkManager == nil)
    {
        sharedNetorkManager = [(AppDelegate *)[[UIApplication sharedApplication] delegate] sharedNetworkManager];
    }
    [self setSharedNetorkManager:sharedNetorkManager];
    
    // if there is no current process going on currently, we need to trigger it
    if([sharedNetorkManager.recreationRunner isProcessCompleted])
    {
        UIBarButtonItem *refreshItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(rightItemButtonWithActivityIndicator)];
        NSArray *actionBarItems = @[refreshItem];
        self.navigationItem.rightBarButtonItems = actionBarItems;
    }
    else    // otherwise, we want to show that we are currently loading data
    {
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [activityIndicator startAnimating];
        UIBarButtonItem *activityItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
        self.navigationItem.rightBarButtonItem = activityItem;
    }
    
    __weak RecreationViewController *inSelf = self;
    __strong NSArray *capturedData;
    
    // set the completion block of the account runner
    [sharedNetorkManager.recreationRunner setUponCompletion:^{
        // we just want to replace the activity indicator with the refresh button at this point
        UIBarButtonItem *refreshItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:inSelf action:@selector(rightItemButtonWithActivityIndicator)];
        
        arrayOfCellData = [sharedNetorkManager.recreationRunner.cachedData objectForKey:@"locations"];

        [inSelf.myTableView reloadData];
        NSArray *actionBarItems = @[refreshItem];
        inSelf.navigationItem.rightBarButtonItems = actionBarItems;
    }];
    
    arrayOfCellData = [[sharedNetorkManager.recreationRunner getCachedData] objectForKey:@"locations"];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arrayOfCellData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f; // you can have your own choice, of course
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CustomRecreationCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSString *cellTitle = [[arrayOfCellData objectAtIndex:indexPath.section] objectForKey:@"locName"];
    NSString *cellValue = [[arrayOfCellData objectAtIndex:indexPath.section] objectForKey:@"traffic"];
    NSString *clutterValue = [[arrayOfCellData objectAtIndex:indexPath.section] objectForKey:@"clutter"];
    RecreationClutterBubble *cellBubbleView = [[RecreationClutterBubble alloc] initWithFrame:CGRectZero];
    
    [[cell cellTitleLabel]setText:cellTitle];
    [[cell cellValueLabel]setText:cellValue];
    //[cell addSubview:cellBubbleView];
    
    if([clutterValue isEqualToString:@"busy"])
        [cell.cellClutterBubble setColor:@"red"];
    else if([clutterValue isEqualToString:@"moderate"])
        [cell.cellClutterBubble setColor:@"yellow"];
    else if([clutterValue isEqualToString:@"free"])
        [cell.cellClutterBubble setColor:@"green"];
    
    [arrayOfCells addObject:cell];
    //[[cell cellClutterBubble] init];
    //[[cell cellImageView] setTextColor:[UIColor colorWithRed:99.0/255.0 green:99.0/255.0 blue:99.0/255.0 alpha:1.0]];
    
    //cell.cellValueLabel.layer.borderColor = [UIColor blackColor].CGColor;
    //scell.cellValueLabel.layer.borderWidth = 1.0;
    //[cell.layer setCornerRadius:7.0f];
    //[cell.layer setMasksToBounds:YES];
    //[cell.frame.size ] = cell.frame.size.width-10;
    return cell;
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    // shouldnt hit considering the view should have already been loaded and we only are calling this on unload, but hey, doesnt hurt
    if(sharedNetorkManager == nil)
    {
        sharedNetorkManager = [(AppDelegate *)[[UIApplication sharedApplication] delegate] sharedNetworkManager];
    }
    [self setSharedNetorkManager:sharedNetorkManager];
    
    [sharedNetorkManager.accountsRunner setUponCompletion:nil];
}

// Function to perform upon refresh button being pressed
// we need to switch the the right bar button to an activity indicator instead of a refresh button
// and begin the loading process
- (void) rightItemButtonWithActivityIndicator
{
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [activityIndicator startAnimating];
    UIBarButtonItem *activityItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    self.navigationItem.rightBarButtonItem = activityItem;
    [sharedNetorkManager.recreationRunner run];
}

-(void) setNewDisplayValues {
    // check to see if we have the existing row to update
    if(arrayOfCellData.count != 0)
    {
        [self rightItemButtonWithActivityIndicator];
    }
    else
    {
        arrayOfCellData = [[sharedNetorkManager.recreationRunner getCachedData] objectForKey:@"locations"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
