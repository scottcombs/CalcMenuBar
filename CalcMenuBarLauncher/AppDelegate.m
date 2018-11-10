//
//  AppDelegate.m
//  CalcMenuBarLauncher
//
//  Created by Scott on 11/6/18.
//  Copyright © 2018 Nutz & Boltz Productions. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application
	NSArray *pathComponents = [[[NSBundle mainBundle] bundlePath] pathComponents];
	pathComponents = [pathComponents subarrayWithRange:NSMakeRange(0, [pathComponents count] - 4)];
	NSString *path = [NSString pathWithComponents:pathComponents];
	[[NSWorkspace sharedWorkspace] launchApplication:path];
	[NSApp terminate:nil];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
	// Insert code here to tear down your application
}


@end
