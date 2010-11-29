//
//  THQueryCell.m
//  Incoming!
//
//  Created by Tyler Hall on 7/4/09.
//  Copyright 2009 Click On Tyler, LLC. All rights reserved.
//

#import "THImageRow.h"

@implementation THImageRow

@synthesize imageName;
@synthesize isShared;

- (BOOL)isOpaque
{
	return YES;
}

- (void)drawInteriorWithFrame:(NSRect)aRect inView:(NSView *)controlView
{
	NSRect txtRect = aRect;
	if(self.imageName == nil) {
		txtRect.origin.x += 8; // Account cell
	} else {
		txtRect.origin.x += 20; // Device cell
	}


	[super drawInteriorWithFrame:txtRect inView:controlView];

	NSImage *img = [NSImage imageNamed:self.imageName];
	[img setFlipped:YES];

	NSRect imgRect = aRect;
	imgRect.size.width = 16;
	imgRect.size.height = 16;
	imgRect.origin.x += 2;
	imgRect.origin.y += 2;
	[img drawInRect:imgRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
	
//	if([self.isShared boolValue]) {
//		img = [NSImage imageNamed:@"share"];
//		[img setFlipped:YES];
//		
//		imgRect = aRect;
//		imgRect.origin.x += imgRect.size.width - 16;
//		
//		imgRect.size.width = 16;
//		imgRect.size.height = 16;
//		imgRect.origin.x += 2;
//		imgRect.origin.y += 2;
//		[img drawInRect:imgRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
//	}
}

@end
