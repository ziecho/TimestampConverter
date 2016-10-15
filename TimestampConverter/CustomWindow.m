//
//  CustomWindow.m
//  TimestampConverter
//
//  Created by zie on 16/4/28.
//  Copyright © 2016年 ziecho.com All rights reserved.
//

#import "CustomWindow.h"

#import <AppKit/AppKit.h>

@implementation CustomWindow

@synthesize initialLocation;

- (id)initWithContentRect:(NSRect)contentRect
                styleMask:(NSWindowStyleMask)aStyle
                  backing:(NSBackingStoreType)bufferingType
                    defer:(BOOL)flag {
    
    self = [super initWithContentRect:contentRect styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
    if (self != nil) {
//        [self setAlphaValue:1.0];
//        [self setOpaque:NO];
        [self setLevel: NSStatusWindowLevel];
        NSView *view = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 30, 30)];
        [view setWantsLayer:YES];
        view.layer.backgroundColor = [[NSColor yellowColor] CGColor];
        
        [self.contentView addSubview:view];
        
        NSRect frame = NSMakeRect(10, 40, 120, 40);
        NSButton* pushButton = [[NSButton alloc] initWithFrame: frame];
        pushButton.bezelStyle = NSRoundedBezelStyle;
        
        [self.contentView addSubview:pushButton];
    }
    return self;
}




- (void)mouseDown:(NSEvent *)theEvent {
    
    self.initialLocation = [theEvent locationInWindow];
}


- (void)mouseDragged:(NSEvent *)theEvent {
    
    NSRect screenVisibleFrame = [[NSScreen mainScreen] visibleFrame];
    NSRect windowFrame = [self frame];
    NSPoint newOrigin = windowFrame.origin;

    NSPoint currentLocation = [theEvent locationInWindow];
    newOrigin.x += (currentLocation.x - initialLocation.x);
    newOrigin.y += (currentLocation.y - initialLocation.y);

    if ((newOrigin.y + windowFrame.size.height) > (screenVisibleFrame.origin.y + screenVisibleFrame.size.height)) {
        newOrigin.y = screenVisibleFrame.origin.y + (screenVisibleFrame.size.height - windowFrame.size.height);
    }
    
    [self setFrameOrigin:newOrigin];
}

@end
