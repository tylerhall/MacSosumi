//
//  SosumiAppDelegate.h
//  Sosumi
//
//  Created by Tyler Hall on 11/28/10.
//  Copyright 2010 Click On Tyler, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@class SSMAccount;

@interface SosumiAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
	IBOutlet NSOutlineView *outlineView;
	IBOutlet WebView *map;
	IBOutlet NSTreeController *treeController;
	IBOutlet NSProgressIndicator *piSpinner;
	
	IBOutlet NSPanel *panelAddAccount;
	IBOutlet NSTextField *txtUsername;
	IBOutlet NSSecureTextField *txtPassword;

	IBOutlet NSPanel *panelSendMessage;
	IBOutlet NSTextField *txtSubject;
	IBOutlet NSTextField *txtMessage;
	IBOutlet NSButton *chkAlarm;
}

@property (assign) IBOutlet NSWindow *window;

- (void)refreshOutline:(NSNotification *)notification;
- (void)refreshMap;

- (IBAction)addAccountWasClicked:(id)sender;
- (IBAction)removeAccountWasClicked:(id)sender;
- (IBAction)refreshWasClicked:(id)sender;
- (IBAction)viewOnMapWasClicked:(id)sender;
- (IBAction)sendMessageWasClicked:(id)sender;
- (IBAction)lockDeviceWasClicked:(id)sender;
- (IBAction)dismissPanel:(id)sender;
- (IBAction)confirmAddAccount:(id)sender;
- (IBAction)confirmSendMessage:(id)sender;
- (IBAction)copyCoordsWasClicked:(id)sender;

- (void)showSpinner:(NSNotification *)notification;
- (void)hideSpinner:(NSNotification *)notification;

@end
