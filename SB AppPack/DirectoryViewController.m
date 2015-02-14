//
//  DirectoryViewController.m
//  SB AppPack
//
//  Created by Richard Hartmann on 10/19/13.
//  Copyright (c) 2013 Richard Hartmann. All rights reserved.
//

#import "DirectoryViewController.h"
#import "DirectorySelectedViewController.h"
#import "AppDelegate.h"

@interface DirectoryViewController ()
{
    NSArray *arrayOfStaff;
}

@end

@implementation DirectoryViewController
@synthesize directorySearchBar,myTableView, sharedNetorkManager;

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
    self.directorySearchBar.delegate = self;
    [self.myTableView setDataSource:self];
    [self.myTableView setDelegate:self];
    
    [super viewDidLoad];
    arrayOfStaff = [[NSArray alloc] init];
	// Do any additional setup after loading the view.
    if(sharedNetorkManager == nil)
    {
        sharedNetorkManager = [(AppDelegate *)[[UIApplication sharedApplication] delegate] sharedNetworkManager];
    }
    [self setSharedNetorkManager:sharedNetorkManager];
    
    __weak DirectoryViewController *inSelf = self;
    
    [self.sharedNetorkManager.directoryRunner setUponCompletion:^(){
        arrayOfStaff = [inSelf.sharedNetorkManager.directoryRunner.cachedData objectForKey:@"people"];
        //[myTableView set]
        [myTableView reloadData];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrayOfStaff.count;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"directorySearchSegue"]){
        DirectorySelectedViewController* vc = (DirectorySelectedViewController*)segue.destinationViewController;
        NSIndexPath * indexPath = [self.myTableView indexPathForCell:sender];
        NSString *passingName = [arrayOfStaff objectAtIndex:indexPath.item];
        [[segue destinationViewController] setDetailItem:passingName];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell.textLabel setText:[arrayOfStaff objectAtIndex:indexPath.row]];

    return cell;
    
}

#pragma mark - UISearchBarDelegate

-(void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        CGRect statusBarFrame =  [[UIApplication sharedApplication] statusBarFrame];
        [UIView animateWithDuration:0.25 animations:^{
            for (UIView *subview in self.view.subviews)
                subview.transform = CGAffineTransformMakeTranslation(0, statusBarFrame.size.height);
        }];
    }
}

-(void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [UIView animateWithDuration:0.25 animations:^{
            for (UIView *subview in self.view.subviews)
                subview.transform = CGAffineTransformIdentity;
        }];
    }
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSMutableDictionary *queryDict = [[NSMutableDictionary alloc] init];
    NSString *searchText = [[NSString alloc] initWithFormat:@"%@", searchBar.text];
    [queryDict setObject:searchText forKey:@"search"];
    [self.sharedNetorkManager.directoryRunner setQueryData: queryDict];
    [self.sharedNetorkManager.directoryRunner run];
    [searchBar resignFirstResponder];
}

-(void) setNewDisplayValues {
    arrayOfStaff = [[sharedNetorkManager.directoryRunner getCachedData] objectForKey:@"people"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
