//
//  ClassesViewController.m
//  SB AppPack
//
//  Created by Richard Hartmann on 11/3/13.
//  Copyright (c) 2013 Richard Hartmann. All rights reserved.
//

#import "ClassesViewController.h"
#import "CustomScheduleCell.h"
#import "AppDelegate.h"
#import "DashboardViewController.h"
#import "ScheduleEntity.h"

@interface ClassesViewController ()
{
    NSMutableArray *arrayOfClasses;
}

@end

@implementation ClassesViewController
@synthesize sharedNetorkManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    // shouldnt hit considering the view should have already been loaded and we only are calling this on unload, but hey, doesnt hurt
    if(sharedNetorkManager == nil)
    {
        sharedNetorkManager = [(AppDelegate *)[[UIApplication sharedApplication] delegate] sharedNetworkManager];
    }
    [self setSharedNetorkManager:sharedNetorkManager];
    
    [sharedNetorkManager.classesRunner setUponCompletion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self myTableView]setDataSource:self];
    [[self myTableView]setDelegate:self];
    
    arrayOfClasses = [[NSMutableArray alloc] init];
    
    if(sharedNetorkManager == nil)
    {
        sharedNetorkManager = [(AppDelegate *)[[UIApplication sharedApplication] delegate] sharedNetworkManager];
    }
    [self setSharedNetorkManager:sharedNetorkManager];
    
    // if there is no current process going on currently, we need to trigger it
    if([sharedNetorkManager.classesRunner isProcessCompleted])
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
    
    __weak ClassesViewController *inSelf = self;
    
    // set the completion block of the account runner
    [sharedNetorkManager.classesRunner setUponCompletion:^{
        // we just want to replace the activity indicator with the refresh button at this point
        UIBarButtonItem *refreshItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:inSelf action:@selector(rightItemButtonWithActivityIndicator)];
        
        [inSelf setNewDisplayValues];
        [inSelf.myTableView reloadData];
        NSArray *actionBarItems = @[refreshItem];
        inSelf.navigationItem.rightBarButtonItems = actionBarItems;
    }];
    
    [inSelf setNewDisplayValues];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrayOfClasses.count;
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
    static NSString *CellIdentifier = @"ClassesCell";
    CustomScheduleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    ScheduleEntity *cellData = [arrayOfClasses objectAtIndex:indexPath.row];
    
    cell.backgroundColor = (indexPath.row%2)
    ? [UIColor whiteColor]
    : UIColorFromRGB(0xC90208);
    
    UIColor *newTextColor = (indexPath.row%2)
    ? [UIColor blackColor]
    : [UIColor whiteColor];
    
    [cell.cellClassDates setTextColor:newTextColor];
    [cell.cellClassLocation setTextColor:newTextColor];
    [cell.cellClassTimes setTextColor:newTextColor];
    [cell.cellClassTitle setTextColor:newTextColor];
    
    [cell.cellClassDates setText:cellData.classDates];
    [cell.cellClassLocation setText:cellData.classLocation];
    [cell.cellClassTimes setText:cellData.classTimes];
    [cell.cellClassTitle setText:cellData.classNameSection];
    
    return cell;
    
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
    [sharedNetorkManager.classesRunner run];
}

-(void)setNewDisplayValues
{
    // check to see if we have the existing row to update
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ScheduleEntity" inManagedObjectContext:self.sharedNetorkManager.managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    NSError *error;
    NSMutableArray *mutableFetchResults = [[self.sharedNetorkManager.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    // we have the row and we just need to update it
    if(mutableFetchResults.count > 0)
    {
        for (int i = 0; i < mutableFetchResults.count; i++) {
            // found entity
            ScheduleEntity* selectedEntity = (ScheduleEntity *)[mutableFetchResults objectAtIndex:i];
            [arrayOfClasses addObject:selectedEntity];
        }
    }
    else
    {
        arrayOfClasses = NULL;
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
