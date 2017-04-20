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
    NSImage *img;
    if([self isAllFilesShownInMac]){
        img = [NSImage imageNamed:@"FolderIcon"];
    }else{
        img = [NSImage imageNamed:@"HiddenFolderIcon"];
    }
    [self.statusItem setImage:img];
    [self.statusItem setAction:@selector(menuClicked:)];
    [self registerLockShortcut];
}

- (void)menuClicked:(id)sender {
    //Below code is to quit app on control click
    NSEvent *event = [NSApp currentEvent];
    if([event modifierFlags] & NSEventModifierFlagControl) {
        [[NSApplication sharedApplication] terminate:self];
        return;
    }
    //update hidden files status
    if([self isAllFilesShownInMac]){
        CFPreferencesSetAppValue(CFSTR("AppleShowAllFiles"), kCFBooleanFalse, CFSTR("com.apple.finder"));
    }else{
        CFPreferencesSetAppValue(CFSTR("AppleShowAllFiles"), kCFBooleanTrue, CFSTR("com.apple.finder"));
    }
    [self killFinder];
    NSString *notifString;
    NSImage *img;
    if([self isAllFilesShownInMac]){
        notifString = @"All files will be dispalyed now";
        img = [NSImage imageNamed:@"FolderIcon"];

    }else
    {
        notifString = @"Hidden files are safe and not visible";
        img = [NSImage imageNamed:@"HiddenFolderIcon"];
    }
    [self.statusItem setImage:img];
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = @"Maṟaikka";
    notification.informativeText = notifString;
    notification.soundName = NSUserNotificationDefaultSoundName;
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}

-(BOOL)isAllFilesShownInMac{
    Boolean show = false;
    Boolean showAllFiles = CFPreferencesGetAppBooleanValue(CFSTR("AppleShowAllFiles"), CFSTR("com.apple.finder"), &show);
    return showAllFiles;
}

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification
{
    return YES;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
}

-(BOOL)checkAccessibilityStatus{
    NSDictionary* opts = @{(__bridge id)kAXTrustedCheckOptionPrompt: @YES};
    return AXIsProcessTrustedWithOptions((__bridge CFDictionaryRef)opts);
}

-(void)registerLockShortcut{
    if ([self checkAccessibilityStatus]) {
        NSLog(@"Accessibility Enabled");
    }
    else {
        NSLog(@"Accessibility Disabled");
    }
    [NSEvent addGlobalMonitorForEventsMatchingMask:NSKeyDownMask handler:^(NSEvent *event) {
        NSUInteger key = 37; // 37 is "L"
        if ([event modifierFlags] & (NSEventModifierFlagControl)) {
            if (event.keyCode == key) {
                [self lockScreen];
            }
        }
    }];
}

- (void)killFinder {
    NSTask *task = [[NSTask alloc] init];
    NSArray *args = @[@"Finder"];
    [task setArguments: args];
    [task setLaunchPath: @"/usr/bin/killall"];
    [task launch];
    [task waitUntilExit];
}

- (void)lockScreen {
    NSTask *task = [[NSTask alloc] init];
    NSArray *args = @[@"-suspend"];
    [task setArguments: args];
    [task setLaunchPath: @"/System/Library/CoreServices/Menu Extras/User.menu/Contents/Resources/CGSession"];
    [task launch];
}

@end
