//
//  THNetworkActivityCell.m
//  Nottingham
//
//  Created by Tyler Hall on 1/15/11.
//  Copyright 2011 Click On Tyler, LLC. All rights reserved.
//

#import "THNetworkActivityCell.h"


@implementation THNetworkActivityCell

@synthesize title;
@synthesize subtitle;

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
	[super drawWithFrame:cellFrame inView:controlView];

	NSRect rect = cellFrame;
	rect.origin.x += 5.0;
	rect.origin.y += 15.0;

	NSMutableAttributedString *as = [[NSMutableAttributedString alloc] initWithString:self.subtitle];
	NSFont *font = [NSFont systemFontOfSize:10.0];
	NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, [NSColor blackColor], NSForegroundColorAttributeName, nil];
	[as addAttributes:attrs range:NSMakeRange(0, [as length])];
	[as drawInRect:rect];
}

@end
