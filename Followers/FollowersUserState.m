//
//  FollowersUserState.m
//  Followers
//
//  Created by Jesse Ditson on 7/28/12.
//  Copyright (c) 2012 Jesse Ditson. All rights reserved.
//

#import "FollowersUserState.h"
#import "Twitter.h"

@implementation FollowersUserState

@synthesize config, currentState;

- (id) initWithReadyCallback:(UserStateResponseBlock)handler {
  if(self = [super init]){
    self.config = [NSUserDefaults standardUserDefaults];
    [self setupWithCompletionHandler:handler];
  }
  return self;
}

+ (NSString *) valueForKey:(NSString *)key {
  NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
  return [config valueForKey:key];
}

- (void) setState:(NSString *)state toValue:(NSString *)value {
  [self.config setObject:value forKey:state];
  [self.config synchronize];
  [self setup];
}

- (NSDictionary *) currentUser {
  NSString *currentUserJson = [self.config objectForKey:@"currentUserJSON"];
  NSLog(@"loaded current user json %@",currentUserJson);
  NSData *userJsonData = [currentUserJson dataUsingEncoding:NSUTF8StringEncoding];
  if(userJsonData){
    NSError *jsonError;
    NSDictionary *user = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:userJsonData options:0 error:&jsonError];
    if(!jsonError){
      return user;
    } else {
      return nil;
    }
  } else {
    return nil;
  }
}

- (void) refreshAccountWithHandler:(UserStateResponseBlock)handler {
  [Twitter currentAccount:^(NSDictionary *account, NSError *error){
    NSLog(@"got current account: %@, error, %@",account,error);
    if(!error){
      NSError *jsonError;
      NSString *jsonUser = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:account options:0 error:&jsonError] encoding:NSUTF8StringEncoding];
      if(jsonError){
        handler(nil,jsonError);
      } else {
        [self.config setObject:jsonUser forKey:@"currentUserJSON"];
        [self.config synchronize];
        handler(account,nil);
      }
    } else {
      handler(nil,error);
    }
  }];
}

- (void) setup {
  [self setupWithCompletionHandler:nil];
}

- (void) setupWithCompletionHandler:(UserStateResponseBlock)handler {
  NSDictionary *currentUser = [self currentUser];
  if(!currentUser){
    NSLog(@"no logged in user found. Getting current user.");
    [self refreshAccountWithHandler:^(NSDictionary *currentUser, NSError *error){
      if(!error){
        [self setupWithCompletionHandler:handler];
      } else {
        NSLog(@"Failed loading user. Logged out.");
        self.currentState = @"loggedOut";
        if(handler) handler(self.currentState,nil);
      }
    }];
  } else {
    NSString *key = [NSString stringWithFormat:@"%@_vipList",[currentUser objectForKey:@"screen_name"]];
    NSString *userHasVIPList = [self.config objectForKey:key];
    NSLog(@"looking for VIP list for user with key %@ - found %@",key,userHasVIPList);
    if(!userHasVIPList){
      NSLog(@"no VIP list found");
      // need to generate vip list
      self.currentState = @"vipList";
    } else {
      // ready to show app
      self.currentState = @"normal";
    }
    if(handler) handler(self.currentState,nil);
  }
}

@end
