//
//  SyncActivityManager.m
//  Nottingham3
//
//  Created by Tyler Hall on 10/10/10.
//  Copyright 2010 Click On Tyler, LLC. All rights reserved.
//

#import "THNetworkActivityManager.h"
#import "THNetworkActivityCell.h"
#import "GTMHTTPFetcher.h"

@implementation THNetworkActivityManager

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addRequest:) name:@"kGTMHTTPFetcherStartedNotification" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeRequest:) name:@"kGTMHTTPFetcherStoppedNotification" object:nil];
	
	return self;
}

- (void)addRequest:(NSNotification *)notification {
	[self addObject:[notification object]];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"SHOW_SPINNER" object:nil];
}

- (void)removeRequest:(NSNotification *)notification {
	[self removeObject:[notification object]];
	if([[self content] count] == 0) {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"HIDE_SPINNER" object:nil];
	}
}

- (void)tableView:(NSTableView *)aTableView willDisplayCell:(id)aCell forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
	THNetworkActivityCell *cell = aCell;

	if([aCell isMemberOfClass:[THNetworkActivityCell class]]) {
		if(rowIndex < [[self arrangedObjects] count]) {
			GTMHTTPFetcher *fetcher = [self arrangedObjects][rowIndex];
			NSDictionary *dict = [fetcher userData];

			NSString *title = [dict valueForKey:@"title"];
			NSString *subtitle = [dict valueForKey:@"subtitle"];
			cell.title = title;
			cell.subtitle = subtitle;
		}
	}
}

@end
