//
//  FollowersLoginView.m
//  Followers
//
//  Created by Jesse Ditson on 7/25/12.
//  Copyright (c) 2012 Jesse Ditson. All rights reserved.
//

#import "FollowersLoginView.h"

@implementation FollowersLoginView

@synthesize authorizeButton,accountSelect,loginButton;

- (IBAction) pressedAuthorizeButton:(id)sender {
  appDelegate = (id)[[NSApplication sharedApplication] delegate];
  ACAccountType *twitterAccountType = [appDelegate.twitterAccountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
  [appDelegate.twitterAccountStore requestAccessToAccountsWithType:twitterAccountType options:nil completion:^(BOOL granted, NSError *err){
    if(granted){
      // allow the user to select an account
      [authorizeButton setEnabled:NO];
      accounts = [appDelegate.twitterAccountStore accountsWithAccountType:twitterAccountType];
      [accountSelect removeAllItems];
      NSMutableArray *accountNames = [NSMutableArray arrayWithCapacity:[accounts count]];
      for(ACAccount *account in accounts){
        [accountNames addObject:[account username]];
      }
      [accountSelect addItemsWithTitles:accountNames];
      [accountSelect setEnabled:YES];
      [loginButton setEnabled:YES];
    } else {
      NSLog(@"User denied twitter access");
    }
  }];
}

- (IBAction)accountSelected:(id)sender {
  // don't need to do anything here
}

- (IBAction)pressedLoginButton:(id)sender {
  NSString *selectedUsername = [accountSelect titleOfSelectedItem];
  ACAccount *selectedAccount;
  // find the account we selected
  for(ACAccount *account in accounts){
    if([[account username] isEqualToString:selectedUsername]){
      selectedAccount = account;
      break;
    }
  }
  appDelegate.twitterAccount = selectedAccount;
  [appDelegate loggedIn];
}

@end
