//
//  NetworkSpinner.h
//  Tennessee Traffic
//
//  Created by Tyler Hall on 8/15/10.
//  Copyright 2010 Click On Tyler, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NetworkSpinner : NSObject {
	int count;
	BOOL hasError;
}

- (void)realQueue;
- (void)realDequeue;
+ (NetworkSpinner *)sharedSpinner;
+ (void)queue;
+ (void)dequeue;
- (void)realHasError;
+ (void)networkError;

@end
