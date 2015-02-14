//
//  RecreationClutterBubble.h
//  SB AppPack
//
//  Created by Richard Hartmann on 11/5/13.
//  Copyright (c) 2013 Richard Hartmann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecreationClutterBubble : UIView {
	CGGradientRef gradient;
	NSArray *colorArray;
}

@property (nonatomic, retain) NSArray *colorArray;
@property (nonatomic, strong, setter = setColor:) NSString *cColor;
void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor);

@end
