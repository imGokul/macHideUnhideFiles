//
//  AppDelegate.m
//  macHideUnhideFiles
//
//  Created by Go on 18/01/15.
//  Copyright (c) 2015 Gokul. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (strong, nonatomic) NSStatusItem *statusItem;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [self.statusItem setHighlightMode:YES];
    NSImage *img = [NSImage imageNamed:@"FolderIcon"];
    [self.statusItem setImage:img];
    [self.statusItem setAction:@selector(menuClicked:)];
}

- (void)menuClicked:(id)sender {
    //Below code is to quit app on control click
    NSEvent *event = [NSApp currentEvent];
    if([event modifierFlags] & NSEventModifierFlagControl) {
        [[NSApplication sharedApplication] terminate:self];
        return;
    }
    
    //update hidden files status
    Boolean show = false;
    Boolean showAllFiles = CFPreferencesGetAppBooleanValue(CFSTR("AppleShowAllFiles"), CFSTR("com.apple.finder"), &show);
    if(showAllFiles){
        CFPreferencesSetAppValue(CFSTR("AppleShowAllFiles"), kCFBooleanFalse, CFSTR("com.apple.finder"));
    }else{
        CFPreferencesSetAppValue(CFSTR("AppleShowAllFiles"), kCFBooleanTrue, CFSTR("com.apple.finder"));
    }
    [[NSTask launchedTaskWithLaunchPath:@"/usr/bin/killall" arguments:@[@"Finder", @"/System/Library/CoreServices/Finder.app"]] waitUntilExit];
    showAllFiles = CFPreferencesGetAppBooleanValue(CFSTR("AppleShowAllFiles"), CFSTR("com.apple.finder"), &show);
    NSString *notifString;
    if(showAllFiles){
        notifString = @"All files will be dispalyed now";
    }else
    {
        notifString = @"Hidden files are safe and not visible";
    }
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = @"Maṟaikka";
    notification.informativeText = notifString;
    notification.soundName = NSUserNotificationDefaultSoundName;
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification
{
    return YES;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
}

@end
