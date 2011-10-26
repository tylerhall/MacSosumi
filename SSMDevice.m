//
//  SSMDevice.m
//  Sosumi
//
//  Created by Tyler Hall on 11/28/10.
//  Copyright 2010 Click On Tyler, LLC. All rights reserved.
//

#import "SSMDevice.h"
#import "SSMAccount.h"

#define SINFO(title, subtitle)	[NSDictionary dictionaryWithObjectsAndKeys:title, @"title", subtitle, @"subtitle", nil]

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
	// The GitHub URLs are just a workaround since me.com's images have been 404'ing lately...
	// NSString *url = [NSString stringWithFormat:@"https://me.com/fmipmobile/deviceImages/Device-%@-%@-mini.png", self.deviceClass, self.deviceModel];
	NSString *url = [NSString stringWithFormat:@"https://github.com/tylerhall/MacSosumi/raw/master/DeviceIcons/Device-Generic-Generic-mini.png", self.deviceClass, self.deviceModel];
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
