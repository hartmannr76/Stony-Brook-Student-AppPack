//
//  RecreationClutterBubble.m
//  SB AppPack
//
//  Created by Richard Hartmann on 11/5/13.
//  Copyright (c) 2013 Richard Hartmann. All rights reserved.
//

#import "RecreationClutterBubble.h"

@implementation RecreationClutterBubble

@synthesize colorArray, cColor;

- (id)initWithFrame:(CGRect)frame color:(NSString *)circleColor
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor)
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    // More coming...
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextSaveGState(context);
    //CGContextAddRect(context, rect);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor * topColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    UIColor * bottomColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];
    UIColor * blackColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]; // NEW
    
    if([cColor isEqual: @"red"])
    {
        topColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
        bottomColor = [UIColor colorWithRed:200.0/255.0 green:0.0 blue:0.0 alpha:1.0];
    }
    else if([cColor isEqual: @"yellow"])
    {
        topColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.0 alpha:1.0];
        bottomColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:0.0 alpha:1.0];
    }
    if([cColor isEqual: @"green"])
    {
        topColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0];
        bottomColor = [UIColor colorWithRed:0.0 green:200.0/255.0 blue:0.0 alpha:1.0];
    }
    
    CGRect paperRect = self.bounds;
    
    drawLinearGradient(context, paperRect, topColor.CGColor, bottomColor.CGColor);
    
    // START NEW
    CGRect strokeRect = CGRectInset(paperRect, 1.0, 1.0);
    CGContextSetStrokeColorWithColor(context, blackColor.CGColor);
    CGContextSetLineWidth(context, 1.0);
    CGContextStrokeEllipseInRect(context, strokeRect);
    // END NEW
}


@end
