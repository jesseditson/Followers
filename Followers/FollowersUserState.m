//
//  FollowersUserState.m
//  Followers
//
//  Created by Jesse Ditson on 7/28/12.
//  Copyright (c) 2012 Jesse Ditson. All rights reserved.
//

#import "FollowersUserState.h"

@implementation FollowersUserState

@synthesize config, currentState;

- (id) init {
  if(self = [super init]){
    self.config = [NSUserDefaults standardUserDefaults];
    [self setup];
  }
  return self;
}

- (void) setState:(NSString *)state toValue:(NSString *)value {
  [self.config setObject:value forKey:state];
  [self.config synchronize];
  [self setup];
}

- (void) setup {
  NSString *userLoggedIn = [self.config objectForKey:@"userLoggedIn"];
  NSString *userHasVIPList = [self.config objectForKey:@"userHasVIPList"];
  if(!userLoggedIn || [userLoggedIn isEqualToString:@"NO"]){
    // user is not logged in
    self.currentState = @"loggedOut";
  } else if(!userHasVIPList || [userHasVIPList isEqualToString:@"NO"]){
    // need to generate vip list
    self.currentState = @"vipList";
  } else {
    // ready to show app
    self.currentState = @"normal";
  }
}

@end
