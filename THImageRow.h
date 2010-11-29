//
//  THQueryCell.h
//  Incoming!
//
//  Created by Tyler Hall on 7/4/09.
//  Copyright 2009 Click On Tyler, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface THImageRow : NSTextFieldCell {
	NSString *imageName;
	NSNumber *isShared;
}

@property (nonatomic, retain) NSString * imageName;
@property (nonatomic, retain) NSNumber * isShared;


@end
