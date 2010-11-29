//
//  SSMDevice.h
//  Sosumi
//
//  Created by Tyler Hall on 11/28/10.
//  Copyright 2010 Click On Tyler, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SSMAccount;

@interface SSMDevice : NSObject {
	BOOL isLocating;
	NSDate *locationTimestamp;
	NSString *locationType;
	NSNumber *horizontalAccuracy;
	BOOL locationFinished;
	NSNumber *longitude;
	NSNumber *latitude;
	NSString *deviceModel;
	NSString *deviceStatus;
	NSString *deviceId;
	NSString *name;
	NSString *deviceClass;
	BOOL isCharging;
	NSNumber *batteryLevel;
	NSString *statusImage;
	SSMAccount *parent;
	NSString *imageURL;
}

@property (assign) BOOL isLocating;
@property (nonatomic, retain) NSDate *locationTimestamp;
@property (nonatomic, retain) NSString *locationType;
@property (nonatomic, retain) NSNumber *horizontalAccuracy;
@property (assign) BOOL locationFinished;
@property (nonatomic, retain) NSNumber *longitude;
@property (nonatomic, retain) NSNumber *latitude;
@property (nonatomic, retain) NSString *deviceModel;
@property (nonatomic, retain) NSString *deviceStatus;
@property (nonatomic, retain) NSString *deviceId;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *deviceClass;
@property (assign) BOOL isCharging;
@property (nonatomic, retain) NSNumber *batteryLevel;
@property (readonly) NSString *statusImage;

@property (nonatomic, retain) SSMAccount *parent;
@property (readonly) NSString *imageURL;

- (NSString *)coords;

@end
