//
//  THHorizontalGradient.m
//  Incoming!
//
//  Created by Tyler Hall on 7/1/09.
//  Copyright 2009 Click On Tyler, LLC. All rights reserved.
//

#import "THGradientBar.h"


@implementation THGradientBar

- (void) drawRect:(NSRect)aRect
{
	// Top inset
	NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithDeviceRed:0.941 green:0.941 blue:0.941 alpha:1.0]
														 endingColor:[NSColor colorWithDeviceRed:0.941 green:0.941 blue:0.941 alpha:1.0]];
	[gradient drawInRect:aRect angle:90];
	
	
	// Top color
	gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithDeviceRed:0.851 green:0.851 blue:0.851 alpha:1.0]
														 endingColor:[NSColor colorWithDeviceRed:0.851 green:0.851 blue:0.851 alpha:1.0]];
	NSRect topRect = aRect;
	topRect.size.height -= 2;
	[gradient drawInRect:topRect angle:90];

	// Bottom color
	gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithDeviceRed:0.8 green:0.8 blue:0.8 alpha:1.0]
														 endingColor:[NSColor colorWithDeviceRed:0.8 green:0.8 blue:0.8 alpha:1.0]];
	NSRect bottomRect = aRect;
	bottomRect.size.height = bottomRect.size.height / 2;
	[gradient drawInRect:bottomRect angle:90];

	
	NSBezierPath *path = [[NSBezierPath alloc] init];
	
	// Bottom Border
	[[NSColor colorWithDeviceRed:0.612 green:0.612 blue:0.612 alpha:1.0] set];
	[path setLineWidth:1.0];
	[path moveToPoint:NSMakePoint(aRect.origin.x, aRect.origin.y)];
	[path lineToPoint:NSMakePoint(aRect.origin.x + aRect.size.width, aRect.origin.y)];
	[path stroke];

	// Top Border
	[[NSColor colorWithDeviceRed:0.659 green:0.659 blue:0.659 alpha:1.0] set];
	[path setLineWidth:1.0];
	[path moveToPoint:NSMakePoint(aRect.origin.x, aRect.origin.y + aRect.size.height)];
	[path lineToPoint:NSMakePoint(aRect.origin.x + aRect.size.width, aRect.origin.y + aRect.size.height)];
	[path stroke];
}

@end
