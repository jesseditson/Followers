//
//  FollowersLoginView.m
//  Followers
//
//  Created by Jesse Ditson on 7/25/12.
//  Copyright (c) 2012 Jesse Ditson. All rights reserved.
//

#import "FollowersLoginView.h"
#import "FollowersAppDelegate.h"

@implementation FollowersLoginView

@synthesize loginButton;

- (IBAction) clickedLoginButton:(id)sender {
  FollowersAppDelegate *appDelegate = (id)[[NSApplication sharedApplication] delegate];
  ACAccountType *twitterAccountType = [appDelegate.twitterAccountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
  [appDelegate.twitterAccountStore requestAccessToAccountsWithType:twitterAccountType options:nil completion:^(BOOL granted, NSError *err){
    if(granted){
      NSArray *accounts = [appDelegate.twitterAccountStore accountsWithAccountType:twitterAccountType];
      // TODO: allow user to select account instead of defaulting to last one.
      appDelegate.twitterAccount = [accounts lastObject];
      [appDelegate loggedIn];
    } else {
      NSLog(@"User denied twitter access");
    }
  }];
}

@end
