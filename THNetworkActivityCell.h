//
//  THNetworkActivityCell.h
//  Nottingham
//
//  Created by Tyler Hall on 1/15/11.
//  Copyright 2011 Click On Tyler, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface THNetworkActivityCell : NSTextFieldCell {
	NSString *title;
	NSString *subtitle;
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subtitle;

@end
