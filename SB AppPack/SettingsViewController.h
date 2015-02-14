//
//  SettingsViewController.h
//  SB AppPack
//
//  Created by Richard Hartmann on 11/3/13.
//  Copyright (c) 2013 Richard Hartmann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *StonyBrookID;
@property (weak, nonatomic) IBOutlet UITextField *SolarPassword;
@property (weak, nonatomic) IBOutlet UITextField *CampusDiningPassword;
- (IBAction)saveSettings:(id)sender;

@end
