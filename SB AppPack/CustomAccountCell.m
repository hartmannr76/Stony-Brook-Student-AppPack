//
//  CustomAccountCell.m
//  SB AppPack
//
//  Created by Richard Hartmann on 10/20/13.
//  Copyright (c) 2013 Richard Hartmann. All rights reserved.
//

#import "CustomAccountCell.h"

@implementation CustomAccountCell

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
    frame.origin.x += 10.0f;
    frame.size.width -= 2 * 10.0f;
    [super setFrame:frame];
}

@end
