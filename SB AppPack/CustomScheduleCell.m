//
//  CustomScheduleCell.m
//  SB AppPack
//
//  Created by Richard Hartmann on 11/3/13.
//  Copyright (c) 2013 Richard Hartmann. All rights reserved.
//

#import "CustomScheduleCell.h"

@implementation CustomScheduleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame {
    frame.origin.x += 12.5f;
    frame.size.width -= 2 * 10.0f;
    [super setFrame:frame];
}

@end
