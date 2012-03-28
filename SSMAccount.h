//
//  SSMAccount.h
//  Sosumi
//
//  Created by Tyler Hall on 11/28/10.
//  Copyright 2010 Click On Tyler, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class GTMHTTPFetcher;

@interface SSMAccount : NSObject {
	NSString *username;
	NSString *password;
	NSMutableDictionary *devices;
	NSString *partition;
	BOOL isUpdating;
	BOOL isRefreshing;
	NSTreeNode *treeNode;

	NSTimer *refreshTimer;
    NSTimeInterval refreshTimerInterval;
}

@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSMutableDictionary *devices;
@property (nonatomic, retain) NSString *partition;
@property (assign) BOOL isUpdating;
@property (assign) BOOL isRefreshing;
@property (nonatomic, retain) NSTreeNode *treeNode;

- (NSString *)apiStringsForMethod:(NSString *)method;

- (void)beginUpdatingDevices;
- (void)stopUpdatingDevices;

- (void)refresh;
- (void)getPartition;
- (void)sendMessage:(NSString *)message withSubject:(NSString *)subject andAlarm:(BOOL)alarm toDevice:(NSString *)deviceId;
- (void)remoteLockDevice:(NSString *)deviceId withPasscode:(NSString *)passcode;

- (GTMHTTPFetcher *)getPreparedFetcherWithMethod:(NSString *)method;

@end
