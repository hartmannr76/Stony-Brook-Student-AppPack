//
//  DirectorySelectedViewController.m
//  SB AppPack
//
//  Created by Richard Hartmann on 11/29/13.
//  Copyright (c) 2013 Richard Hartmann. All rights reserved.
//

#import "DirectorySelectedViewController.h"
#import "AppDelegate.h"

@interface DirectorySelectedViewController ()

@end

@implementation DirectorySelectedViewController
@synthesize selectedName,sharedNetorkManager,officeHoursTable;
@synthesize nameLabel = _nameLabel;
@synthesize emailLabel = _emailLabel;
@synthesize departmentLabel = _departmentLabel;
@synthesize phoneLabel = _phoneLabel;

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];

    }
}

- (void)configureView
{
    
    // Update the user interface for the detail item.
    if(sharedNetorkManager == nil)
    {
        sharedNetorkManager = [(AppDelegate *)[[UIApplication sharedApplication] delegate] sharedNetworkManager];
    }
    
    [self setSharedNetorkManager:sharedNetorkManager];
    if (self.detailItem && [self.detailItem isKindOfClass:[NSString class]]) {
        selectedName = [NSString stringWithFormat:@"%@", self.detailItem];
        NSLog(@"Name: %@", selectedName);
        NSMutableDictionary *queryDict = [[NSMutableDictionary alloc] init];
        NSString *searchText = [[NSString alloc] initWithFormat:@"%@", selectedName];
        [queryDict setObject:searchText forKey:@"search"];
        [sharedNetorkManager.directorySelectedRunner setQueryData:queryDict];
    }
    
    [self.sharedNetorkManager.directorySelectedRunner setUponCompletion:^() {
        NSDictionary *dataSet = [self.sharedNetorkManager.directorySelectedRunner getCachedData];
        
        [self.nameLabel setText:selectedName];
        [self.emailLabel setText:[dataSet objectForKey:@"email"]];
        [self.departmentLabel setText:[dataSet objectForKey:@"department"]];
        if([dataSet objectForKey:@"phone"] == (id)[NSNull null])
        {
            [self.phoneLabel setText:@"N/A"];
        }
        else
        {
            [self.phoneLabel setText:[dataSet objectForKey:@"phone"]];
        }
        
    }];
    
    
    [self.sharedNetorkManager.directorySelectedRunner run];
    
}

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
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
