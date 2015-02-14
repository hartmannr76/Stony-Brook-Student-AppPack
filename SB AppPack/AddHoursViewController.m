//
//  AddHoursViewController.m
//  SB AppPack
//
//  Created by Richard Hartmann on 12/2/13.
//  Copyright (c) 2013 Richard Hartmann. All rights reserved.
//

#import "AddHoursViewController.h"

@interface AddHoursViewController ()
{
    UIDatePicker *startDatePicker;
    UIDatePicker *endDatePicker;
    UIPickerView *daysPicker;
    NSArray *daysArray;
}
@end

@implementation AddHoursViewController
@synthesize dayTextField, startTimeTextField, endTimeTextField;
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
    startDatePicker = [[UIDatePicker alloc] init];
    endDatePicker = [[UIDatePicker alloc] init];
    daysPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, 320, 200)];
    daysPicker.showsSelectionIndicator = YES;
    daysArray = [[NSArray alloc] initWithObjects:@"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", nil];
    
    [super viewDidLoad];
    
    [startDatePicker setDatePickerMode:UIDatePickerModeTime];
    [startDatePicker setMinuteInterval:5];
    [startDatePicker addTarget:self action:@selector(changeStartDateInLabel:) forControlEvents:UIControlEventValueChanged];
    
    [endDatePicker setDatePickerMode:UIDatePickerModeTime];
    [endDatePicker setMinuteInterval:5];
    [endDatePicker addTarget:self action:@selector(changeEndDateInLabel:) forControlEvents:UIControlEventValueChanged];
    
    [daysPicker setDelegate:self];
    [daysPicker setDataSource:self];
    
    [startTimeTextField setDelegate:self];
    [startTimeTextField setInputView:startDatePicker];
    [endTimeTextField setDelegate:self];
    [endTimeTextField setInputView:endDatePicker];
    [dayTextField setDelegate:self];
    [dayTextField setInputView:daysPicker];
	// Do any additional setup after loading the view.
}

-(void)changeStartDateInLabel:(id)sender{
    NSDateFormatter *df = [[NSDateFormatter alloc] init]; df.dateStyle = NSDateFormatterMediumStyle;
    [df setDateFormat:@"h:mm a"];
    
    startTimeTextField.text = [NSString stringWithFormat:@"%@", [df stringFromDate:startDatePicker.date]];
}

-(void)changeEndDateInLabel:(id)sender{
    NSDateFormatter *df = [[NSDateFormatter alloc] init]; df.dateStyle = NSDateFormatterMediumStyle;
    [df setDateFormat:@"h:mm a"];
    
    endTimeTextField.text = [NSString stringWithFormat:@"%@", [df stringFromDate:endDatePicker.date]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    dayTextField.text = [daysArray objectAtIndex:row];
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)daysPicker numberOfRowsInComponent:(NSInteger)component {
    return daysArray.count;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)daysPicker {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)daysPicker titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return [daysArray objectAtIndex:row];
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)daysPicker widthForComponent:(NSInteger)component {
    int sectionWidth = 300;
    
    return sectionWidth;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender {
    [self dismissModalViewControllerAnimated: YES];
}

- (IBAction)done:(id)sender {
    //check to see if the times are not correct
    
    // send the data to server
    [self dismissModalViewControllerAnimated: YES];
}
@end
