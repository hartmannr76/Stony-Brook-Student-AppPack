//
//  CustomRecreationCell.h
//  SB AppPack
//
//  Created by Richard Hartmann on 11/5/13.
//  Copyright (c) 2013 Richard Hartmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecreationClutterBubble.h"

@interface CustomRecreationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cellTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellValueLabel;
@property (weak, nonatomic) IBOutlet RecreationClutterBubble *cellClutterBubble;
@end
