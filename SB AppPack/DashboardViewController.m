//
//  DashboardViewController.m
//  CollectionViewDemo
//
//  Created by Richard Hartmann on 10/1/13.
//  Copyright (c) 2013 Richard Hartmann. All rights reserved.
//

#import "DashboardViewController.h"
#import "DirectoryViewController.h"
#import "AccountsViewController.h"

@interface DashboardViewController ()
{
    NSArray *arrayOfImages;
    NSArray *arrayOfLabels;
    NSMutableArray *arrayOfCells;
}
@end

@implementation DashboardViewController
@synthesize selectedCell;
@synthesize tapper;



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self myCollectionView]setDataSource:self];
    [[self myCollectionView]setDelegate:self];
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapper:)];
    
    [self.myCollectionView addGestureRecognizer:tapper];
    
	arrayOfImages = [[NSArray alloc]initWithObjects:@"d", @"c", @"g", @"b", @"a", @"f", nil];
    arrayOfLabels = [[NSArray alloc]initWithObjects:@"Directory", @"Accounts", @"Schedule", @"Recreation", @"Settings", @"Info", nil];
    arrayOfCells = [[NSMutableArray alloc] init];

    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0xC90208)];
    [self.myCollectionView setBackgroundColor:UIColorFromRGB(0xE0DADA)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [arrayOfLabels count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CustomDashboardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [[cell cellImageView]setText:[arrayOfImages objectAtIndex:indexPath.item]];
    [[cell cellImageView] setFont:[UIFont fontWithName:@"sb-appfont2" size:80]];
    [[cell cellImageView] setTextColor:[UIColor colorWithRed:99.0/255.0 green:99.0/255.0 blue:99.0/255.0 alpha:1.0]];
    [[cell cellDescriptionLabel] setText:[arrayOfLabels objectAtIndex:indexPath.item]];
    [[cell cellDescriptionLabel] setTextColor:[UIColor colorWithRed:99.0/255.0 green:99.0/255.0 blue:99.0/255.0 alpha:1.0]];
    NSLog(@"Selected cell: %@", cell.cellDescriptionLabel.text);
    [arrayOfCells addObject:cell];
    
    return cell;
}

- (IBAction)tapper:(UITapGestureRecognizer *)gesture {
    
    CGPoint tapLocation = [gesture locationInView:self.myCollectionView];
    NSIndexPath *indexPath = [self.myCollectionView indexPathForItemAtPoint:tapLocation];
    //static NSString *CellIdentifier = @"Cell";
    if (indexPath) {
        self.selectedCell = [arrayOfCells objectAtIndex:[indexPath item]];
        
        NSLog(@"Selected cell: %@", self.selectedCell.cellDescriptionLabel.text);
        
        if(indexPath.item == 0)
            [self performSegueWithIdentifier:@"directorySegue" sender:self];
        else if(indexPath.item == 1)
            [self performSegueWithIdentifier:@"accountsSegue" sender:self];
        else if(indexPath.item == 2)
            [self performSegueWithIdentifier:@"classesSegue" sender:self];
        else if(indexPath.item == 3)
            [self performSegueWithIdentifier:@"recreationSegue" sender:self];
        else if(indexPath.item == 4)
            [self performSegueWithIdentifier:@"settingsSegue" sender:self];
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"directorySegue"]){
        //DirectoryViewController* vc = (DirectoryViewController*)segue.destinationViewController;
        //vc.selectedCell = self.selectedCell;
    }
    else if ([segue.identifier isEqualToString:@"accountsSegue"]) {
        //AccountsViewController* sc = (AccountsViewController*)segue.destinationViewController;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
