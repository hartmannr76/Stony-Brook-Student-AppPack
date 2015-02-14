//
//  AccountsViewController.m
//  SB AppPack
//
//  Created by Richard Hartmann on 10/19/13.
//  Copyright (c) 2013 Richard Hartmann. All rights reserved.
//

#import "AccountsViewController.h"
#import "AppDelegate.h"
#import "AccountsEntity.h"
#import <QuartzCore/QuartzCore.h>
#import <QuartzCore/CALayer.h>

@interface AccountsViewController ()
{
    NSArray *arrayOfCellNames;
    NSArray *arrayOfCellData;
    NSMutableArray *arrayOfCells;
    AccountsEntity *currentSet;
    NSString *campusPointsValue;
    NSString *flexPointsValue;
    NSString *bookstorePointsValue;
    NSString *wolfieWalletValue;
}

@end

@implementation AccountsViewController
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
    
    if(sharedNetorkManager == nil)
    {
        sharedNetorkManager = [(AppDelegate *)[[UIApplication sharedApplication] delegate] sharedNetworkManager];
    }
    [self setSharedNetorkManager:sharedNetorkManager];
    
    // if there is no current process going on currently, we need to trigger it
    if([sharedNetorkManager.accountsRunner isProcessCompleted])
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
    
    __weak AccountsViewController *inSelf = self;
    
    // set the completion block of the account runner
    [sharedNetorkManager.accountsRunner setUponCompletion:^{
        // we just want to replace the activity indicator with the refresh button at this point
        UIBarButtonItem *refreshItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:inSelf action:@selector(rightItemButtonWithActivityIndicator)];
        
        [inSelf setNewDisplayValues];
        arrayOfCellData = [NSArray arrayWithObjects:campusPointsValue, flexPointsValue, bookstorePointsValue, wolfieWalletValue, nil];
        [inSelf.myTableView reloadData];
        NSArray *actionBarItems = @[refreshItem];
        inSelf.navigationItem.rightBarButtonItems = actionBarItems;
    }];
    
    [inSelf setNewDisplayValues];
    arrayOfCellNames = [[NSArray alloc]initWithObjects:@"Campus Points", @"Flex", @"Bookstore", @"Wallet", nil];
    arrayOfCellData = [[NSArray alloc]initWithObjects:campusPointsValue, flexPointsValue, bookstorePointsValue, wolfieWalletValue, nil];
    arrayOfCells = [[NSMutableArray alloc] init];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
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
    CustomAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [[cell cellTitleLabel]setText:[arrayOfCellNames objectAtIndex:indexPath.section]];
    [[cell cellValueLabel]setText:[arrayOfCellData objectAtIndex:indexPath.section]];
    //[[cell cellImageView] setTextColor:[UIColor colorWithRed:99.0/255.0 green:99.0/255.0 blue:99.0/255.0 alpha:1.0]];
    //[[cell cellDescriptionLabel] setText:[arrayOfLabels objectAtIndex:indexPath.item]];
    //[[cell cellDescriptionLabel] setTextColor:[UIColor colorWithRed:99.0/255.0 green:99.0/255.0 blue:99.0/255.0 alpha:1.0]];
    NSLog(@"Selected cell: %@", cell.cellTitleLabel.text);
    [arrayOfCells addObject:cell];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [sharedNetorkManager.accountsRunner run];
}

-(void) initDataModelForView {
    
}

-(void) setNewDisplayValues {
    // check to see if we have the existing row to update
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AccountsEntity" inManagedObjectContext:self.sharedNetorkManager.managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    NSError *error;
    NSMutableArray *mutableFetchResults = [[self.sharedNetorkManager.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    // we have the row and we just need to update it
    if(mutableFetchResults.count > 0)
    {
        // found entity
        AccountsEntity* selectedEntity = (AccountsEntity *)[mutableFetchResults objectAtIndex:0];
        wolfieWalletValue = [NSString stringWithFormat:@"$%@", [selectedEntity.wolfieWallet stringValue]];
        bookstorePointsValue = [NSString stringWithFormat:@"$%@", [selectedEntity.bookstorePoints stringValue]];
        campusPointsValue = [NSString stringWithFormat:@"$%@", [selectedEntity.mealPoints stringValue]];
        flexPointsValue = [NSString stringWithFormat:@"$%@", [selectedEntity.flexPoints stringValue]];
    }
    else
    {
        wolfieWalletValue = @"$0.00";
        bookstorePointsValue = @"$0.00";
        campusPointsValue = @"$0.00";
        flexPointsValue = @"$0.00";
    }

}

@end
