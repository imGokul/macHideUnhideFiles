//
//  AppDelegate.m
//  macHideUnhideFiles
//
//  Created by Go on 18/01/15.
//  Copyright (c) 2015 Gokul. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (strong, nonatomic) IBOutlet NSMenu *statusMenu;
@property (strong, nonatomic) NSStatusItem *statusItem;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [self.statusItem setMenu:self.statusMenu];
    [self.statusItem setTitle:@"..."];
    [self.statusItem setHighlightMode:YES];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
}

- (IBAction)ShowHiddenFiles{
}


- (IBAction)HideHiddenFiles{
}

@end
