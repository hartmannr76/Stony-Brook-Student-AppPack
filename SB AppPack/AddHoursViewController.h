//
//  AddHoursViewController.h
//  SB AppPack
//
//  Created by Richard Hartmann on 12/2/13.
//  Copyright (c) 2013 Richard Hartmann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddHoursViewController : UIViewController <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, weak) IBOutlet UITextField *dayTextField;
@property (nonatomic, weak) IBOutlet UITextField *startTimeTextField;
@property (nonatomic, weak) IBOutlet UITextField *endTimeTextField;
- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;
@end
