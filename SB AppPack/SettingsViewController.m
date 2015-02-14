//
//  SettingsViewController.m
//  SB AppPack
//
//  Created by Richard Hartmann on 11/3/13.
//  Copyright (c) 2013 Richard Hartmann. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController
@synthesize StonyBrookID, SolarPassword, CampusDiningPassword;

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
    // Get the stored data before the view loads
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *stonyBrookId = [defaults objectForKey:@"stonyBrookId"];
    NSString *solarPassword = [defaults objectForKey:@"solarPassword"];
    NSString *campusDiningPassword  = [defaults objectForKey:@"campusDiningPassword"];
    // Update the UI elements with the saved data
    StonyBrookID.text = stonyBrookId;
    SolarPassword.text = solarPassword;
    CampusDiningPassword.text = campusDiningPassword;
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveSettings:(id)sender {
    // Hide the keyboard
    [StonyBrookID resignFirstResponder];
    [SolarPassword resignFirstResponder];
    [CampusDiningPassword resignFirstResponder];
    // Create strings and integer to store the text info
    NSString *stonyBrookId = [StonyBrookID text];
    NSString *solarPassword  = [SolarPassword text];
    NSString *campusDiningPassword  = [CampusDiningPassword text];
    // Store the data
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:stonyBrookId forKey:@"stonyBrookId"];
    [defaults setObject:solarPassword forKey:@"solarPassword"];
    [defaults setObject:campusDiningPassword forKey:@"campusDiningPassword"];
    [defaults synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
