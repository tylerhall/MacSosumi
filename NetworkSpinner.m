//
//  NetworkSpinner.m
//  Tennessee Traffic
//
//  Created by Tyler Hall on 8/15/10.
//  Copyright 2010 Click On Tyler, LLC. All rights reserved.
//

#import "NetworkSpinner.h"

static NetworkSpinner *_me = nil;

@implementation NetworkSpinner

- (id)init {
	[super init];
	count = 0;
	hasError = NO;
	return self;
}

+ (NetworkSpinner *)sharedSpinner {
	if(_me == nil) {
		_me = [[NetworkSpinner alloc] init];
	}
	return _me;
}

- (void)realQueue {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"SHOW_SPINNER" object:self];
	count++;
}

- (void)realDequeue {
	count--;
	if(count <= 0) {
		count = 0;
		[[NSNotificationCenter defaultCenter] postNotificationName:@"HIDE_SPINNER" object:self];
	}
}

+ (void)queue {
	NetworkSpinner *fakeMe = [NetworkSpinner sharedSpinner];
	[fakeMe realQueue];
}

+ (void)dequeue {
	NetworkSpinner *fakeMe = [NetworkSpinner sharedSpinner];
	[fakeMe realDequeue];
}

- (void)realHasError {
	if(hasError) return;
	hasError = YES;
//	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"TN Traffic could not connect to the network. Please try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//	[alert show];
//	[alert release];	
}	
	
+ (void)networkError {
	[[NetworkSpinner sharedSpinner] realHasError];
}

//- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
//	hasError = NO;
//}

@end
