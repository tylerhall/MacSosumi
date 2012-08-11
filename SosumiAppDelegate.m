//
//  SosumiAppDelegate.m
//  Sosumi
//
//  Created by Tyler Hall on 11/28/10.
//  Copyright 2010 Click On Tyler, LLC. All rights reserved.
//

#import "SosumiAppDelegate.h"
#import "SSMAccount.h"
#import "SSMDevice.h"
#import "THImageRow.h"
#import "EMKeychainItem.h"

@implementation SosumiAppDelegate

@synthesize window;
@synthesize panelSyncActivity;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshOutline:) name:@"DEVICES_DID_UPDATE" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSpinner:) name:@"SHOW_SPINNER" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideSpinner:) name:@"HIDE_SPINNER" object:nil];

	NSArray *accounts = [[NSUserDefaults standardUserDefaults] objectForKey:@"accounts"];
	if(accounts == nil) {
		[self addAccountWasClicked:self];
	} else {
		for(NSDictionary *dict in accounts) {
			NSTreeNode *treeNode;
			SSMAccount *tmpAccount = [[SSMAccount alloc] init];
			tmpAccount.username = dict[@"username"];
			EMGenericKeychainItem *kcItem = [EMGenericKeychainItem genericKeychainItemForService:@"Sosumi" withUsername:tmpAccount.username];
			tmpAccount.password = kcItem.password;
			[tmpAccount beginUpdatingDevices];
			treeNode = [NSTreeNode treeNodeWithRepresentedObject:tmpAccount];
			tmpAccount.treeNode = treeNode;
			[treeController insertObject:treeNode atArrangedObjectIndexPath:[NSIndexPath indexPathWithIndex:0]];
		}
	}

	// In an old version we were storing the user's password in NSUserDefaults. After we switched to using the Keychain,
	// we forgot to erase the old password from disk. This fixes that.
	NSMutableArray *fixedAccounts = [NSMutableArray array];
	for(int i = 0; i < [accounts count]; i++) {
		NSDictionary *credentials = accounts[i];
		NSDictionary *dict = @{@"username": credentials[@"username"]};
		[fixedAccounts addObject:dict];
	}
	[[NSUserDefaults standardUserDefaults] setObject:fixedAccounts forKey:@"accounts"];
	[[NSUserDefaults standardUserDefaults] synchronize];

	[self refreshOutline:nil];

    NSString *html = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"map" ofType:@"html"] encoding:NSUTF8StringEncoding error:nil];
	[[map mainFrame] loadHTMLString:html baseURL:[NSURL URLWithString:@"http://maps.google.com"]];
}

- (BOOL)applicationShouldOpenUntitledFile:(NSApplication *)sender
{
	[window makeKeyAndOrderFront:self];
	return NO;
}

#pragma mark -
#pragma mark Outline View Delegates
#pragma mark -

- (void)outlineView:(NSOutlineView *)outlineView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
	id device = [[item representedObject] representedObject];
	if([device isKindOfClass:[SSMDevice class]]) {
		[(THImageRow *)cell setImageName:[(SSMDevice *)device statusImage]];
	} else {
		[(THImageRow *)cell setImageName:nil];
	}
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item
{
	return [[[item representedObject] representedObject] isKindOfClass:[SSMAccount class]];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldShowOutlineCellForItem:(id)item
{
	return NO;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item
{
	return ![[[item representedObject] representedObject] isKindOfClass:[SSMAccount class]];
}

- (void)refreshOutline:(NSNotification *)notification
{
	[outlineView reloadData];
	[outlineView expandItem:nil expandChildren:YES];
	[self refreshMap];
}

#pragma mark -
#pragma mark Split View Delegates
#pragma mark -

- (BOOL)splitView:(NSSplitView *)splitView shouldAdjustSizeOfSubview:(NSView *)subview
{
	if(subview == [splitView subviews][0]) {
		return NO;
	}
	
	return YES;
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedMin ofSubviewAt:(NSInteger)dividerIndex
{
	return 150.0;
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedMin ofSubviewAt:(NSInteger)dividerIndex
{
	return 350.0;
}

#pragma mark -
#pragma mark Webview Delgates
#pragma mark -

- (void)refreshMap
{
	NSArray *args;

	WebScriptObject *ws = [map windowScriptObject];

	for(NSTreeNode *accountTreeNode in [treeController content]) {
		for(NSTreeNode *deviceTreeNode in [accountTreeNode childNodes]) {
			SSMDevice *device = [deviceTreeNode representedObject];
			if(device.latitude != nil && device.longitude != nil) {
				// NSLog(@"mapped %@ %@ %@", device.name, device.latitude, device.longitude);
				args = @[device.deviceId, device.name, device.latitude, device.longitude, device.imageURL];
				[ws callWebScriptMethod:@"createMarker" withArguments:args];
			}
		}
	}
}

#pragma mark -
#pragma mark IBActions
#pragma mark -

- (IBAction)addAccountWasClicked:(id)sender
{
	[txtUsername setStringValue:@""];
	[txtPassword setStringValue:@""];
	[NSApp beginSheet:panelAddAccount modalForWindow:self.window modalDelegate:self didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) contextInfo:NULL];
}

- (IBAction)removeAccountWasClicked:(id)sender
{
	if([[treeController selectedNodes] count] == 0) {
		return;
	}
	
	NSTreeNode *treeNode = [treeController selectedNodes][0];
	SSMAccount *account = [[[treeNode parentNode] representedObject] representedObject];
	
	EMGenericKeychainItem *kcItem = [EMGenericKeychainItem genericKeychainItemForService:@"Sosumi" withUsername:account.username];
	if(kcItem) {
		[kcItem removeFromKeychain];
	}
	
	NSMutableArray *accounts = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"accounts"]];
	if(accounts) {
		for(int i = 0; i < [accounts count]; i++) {
			NSDictionary *tmpAccount = accounts[i];
			if([tmpAccount[@"username"] isEqualToString:account.username]) {
				[accounts removeObject:tmpAccount];
			}
		}
	}

	[[NSUserDefaults standardUserDefaults] setObject:accounts forKey:@"accounts"];
	[[NSUserDefaults standardUserDefaults] synchronize];

	[treeController removeObjectAtArrangedObjectIndexPath:[[treeNode parentNode] indexPath]];
}

- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{

}

- (IBAction)viewOnMapWasClicked:(id)sender
{
	if([[treeController selectedNodes] count] == 0) {
		return;
	}
	
	NSTreeNode *node = [treeController selectedNodes][0];
	SSMDevice *device = [[node representedObject] representedObject];

	WebScriptObject *ws = [map windowScriptObject];
	NSArray *args = @[device.deviceId];
	[ws callWebScriptMethod:@"viewOnMap" withArguments:args];
}

- (IBAction)refreshWasClicked:(id)sender
{
	for(NSTreeNode *accountTreeNode in [treeController content]) {
		SSMAccount *account = [accountTreeNode representedObject];
		[account refresh];
	}	
}

- (IBAction)sendMessageWasClicked:(id)sender
{
	[txtSubject setStringValue:@""];
	[txtMessage setStringValue:@""];
	[chkAlarm setState:NSOffState];
	[NSApp beginSheet:panelSendMessage modalForWindow:self.window modalDelegate:self didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) contextInfo:NULL];
}

- (IBAction)lockDeviceWasClicked:(id)sender
{
	if([[treeController selectedNodes] count] == 0) {
		return;
	}
	
	NSTreeNode *node = [treeController selectedNodes][0];
	SSMDevice *device = [[node representedObject] representedObject];

	SSMAccount *account = [[[node parentNode] representedObject] representedObject];
	[account remoteLockDevice:device.deviceId withPasscode:@"9911"];
}

- (IBAction)dismissPanel:(id)sender
{
	[NSApp endSheet:panelSendMessage returnCode:NSCancelButton];
	[panelSendMessage orderOut:nil];

	[NSApp endSheet:panelAddAccount returnCode:NSCancelButton];
	[panelAddAccount orderOut:nil];
}

- (IBAction)confirmAddAccount:(id)sender
{
	EMGenericKeychainItem *kcItem = [EMGenericKeychainItem genericKeychainItemForService:@"Sosumi" withUsername:[txtUsername stringValue]];
	if(kcItem) {
		kcItem.password = [txtPassword stringValue];
	} else {
		kcItem = [EMGenericKeychainItem addGenericKeychainItemForService:@"Sosumi" withUsername:[txtUsername stringValue] password:[txtPassword stringValue]];
	}

	NSTreeNode *treeNode;
	SSMAccount *tmpAccount = [[SSMAccount alloc] init];
	tmpAccount.username = kcItem.username;
	tmpAccount.password = kcItem.password;
	treeNode = [NSTreeNode treeNodeWithRepresentedObject:tmpAccount];
	tmpAccount.treeNode = treeNode;
	[tmpAccount beginUpdatingDevices];
	
	[treeController insertObject:treeNode atArrangedObjectIndexPath:[NSIndexPath indexPathWithIndex:0]];

	NSMutableArray *accounts = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"accounts"]];
	[accounts addObject:[NSDictionary dictionaryWithObjects:@[kcItem.username] forKeys:@[@"username"]]];
	[[NSUserDefaults standardUserDefaults] setObject:accounts forKey:@"accounts"];
	[[NSUserDefaults standardUserDefaults] synchronize];

	[NSApp endSheet:panelAddAccount returnCode:NSOKButton];
	[panelAddAccount orderOut:nil];
}

- (IBAction)confirmSendMessage:(id)sender
{
	if([[treeController selectedNodes] count] == 0) {
		return;
	}
	
	NSTreeNode *node = [treeController selectedNodes][0];
	SSMDevice *device = [[node representedObject] representedObject];
	SSMAccount *account = [[[node parentNode] representedObject] representedObject];
	[account sendMessage:[txtMessage stringValue] withSubject:[txtSubject stringValue] andAlarm:[chkAlarm state] toDevice:device.deviceId];

	[NSApp endSheet:panelSendMessage returnCode:NSOKButton];
	[panelSendMessage orderOut:nil];
}

- (IBAction)copyCoordsWasClicked:(id)sender
{
	if([[treeController selectedNodes] count] == 0) {
		return;
	}
	
	NSTreeNode *node = [treeController selectedNodes][0];
	SSMDevice *device = [[node representedObject] representedObject];

	NSPasteboard *pb = [NSPasteboard generalPasteboard];
    NSArray *types = @[NSStringPboardType];
    [pb declareTypes:types owner:self];
    [pb setString:[device coords] forType:NSStringPboardType];
}

- (IBAction)showSyncActivityPanel:(id)sender
{
	if([self.panelSyncActivity isVisible]) {
		[self.panelSyncActivity close];
	} else {
		[self.panelSyncActivity orderFront:nil];
	}
}

#pragma mark -
#pragma mark Misc
#pragma mark -

- (void)showSpinner:(NSNotification *)notification
{
	[piSpinner startAnimation:self];
}

- (void)hideSpinner:(NSNotification *)notification
{
	[piSpinner stopAnimation:self];
}

@end
