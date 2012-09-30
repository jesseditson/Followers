//
//  FollowersLoginView.h
//  Followers
//
//  Created by Jesse Ditson on 7/25/12.
//  Copyright (c) 2012 Jesse Ditson. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Accounts/Accounts.h>
#import "FollowersAppDelegate.h"

@interface FollowersLoginView : NSView {
  NSArray *accounts;
  FollowersAppDelegate *appDelegate;
}

@property (assign) IBOutlet NSButton *authorizeButton;
@property (assign) IBOutlet NSButton *loginButton;
@property (assign) IBOutlet NSPopUpButton *accountSelect;

- (IBAction) pressedAuthorizeButton:(id)sender;
- (IBAction) accountSelected:(id)sender;
- (IBAction) pressedLoginButton:(id)sender;


@end
