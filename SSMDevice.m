//
//  SSMDevice.m
//  Sosumi
//
//  Created by Tyler Hall on 11/28/10.
//  Copyright 2010 Click On Tyler, LLC. All rights reserved.
//

#import "SSMDevice.h"
#import "SSMAccount.h"

@implementation SSMDevice

@synthesize isLocating;
@synthesize locationTimestamp; //
@synthesize locationType; //
@synthesize horizontalAccuracy; //
@synthesize locationFinished;
@synthesize longitude; //
@synthesize latitude; //
@synthesize deviceModel; //
@synthesize deviceStatus; //
@synthesize deviceId;
@synthesize name;
@synthesize deviceClass;
@synthesize isCharging; //
@synthesize batteryLevel; //

@synthesize parent;

- (NSString *)imageURL
{
	NSString *url = [NSString stringWithFormat:@"https://me.com/fmipmobile/deviceImages/Device-%@-%@-mini.png", self.deviceClass, self.deviceModel];
	return url;
}

- (NSString *)statusImage
{
	if(self.latitude == nil || self.longitude == nil) {
		return @"red";
	}
	
	return @"green";
}

- (NSString *)coords
{
	if(self.latitude == nil || self.longitude == nil) {
		return @"";
	} else {
		return [NSString stringWithFormat:@"%@, %@", self.latitude, self.longitude];
	}
}

- (NSString *)deviceType
{
	return [NSString stringWithFormat:@"%@ %@", self.deviceClass, self.deviceModel];
}

- (NSString *)charging
{
	return self.isCharging ? @"Yes" : @"No";
}

- (NSString *)battery
{
	int level = [self.batteryLevel floatValue] * 100;
	return [NSString stringWithFormat:@"%d%%", level];
}

@end
