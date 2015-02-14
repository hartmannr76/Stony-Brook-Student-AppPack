//
//  CustomScheduleCell.h
//  SB AppPack
//
//  Created by Richard Hartmann on 11/3/13.
//  Copyright (c) 2013 Richard Hartmann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomScheduleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cellClassTitle;
@property (weak, nonatomic) IBOutlet UILabel *cellClassDates;
@property (weak, nonatomic) IBOutlet UILabel *cellClassTimes;
@property (weak, nonatomic) IBOutlet UILabel *cellClassLocation;
@end
