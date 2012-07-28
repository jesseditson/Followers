//
//  Twitter.m
//  Followers
//
//  Created by Jesse Ditson on 7/27/12.
//  Copyright (c) 2012 Jesse Ditson. All rights reserved.
//

#import "Twitter.h"
#import "FollowersAppDelegate.h"

@implementation Twitter

#pragma mark - friends & followers

+ (void) followersForUser:(NSString *)userId handler:(TwitterResponseBlock)handler {
  [self followerIdsForUser:userId handler:^(NSArray *followerIds, NSError *error){
    NSLog(@"Got follower ids: %@",followerIds);
    [self lookupUsersByIds:followerIds handler:^(NSArray *users, NSError *error){
      // TODO: handle errors
      handler(users,nil);
    }];
  }];
}

+ (void) followerIdsForUser:(NSString *)userId handler:(TwitterResponseBlock)handler {
  // get all the follower ids
  [self followerIdsForUser:userId withIds:[NSArray array] andCursor:[NSNumber numberWithInt:-1] handler:handler];
}

+ (void) followerIdsForUser:(NSString *)userId withIds:(NSArray *)ids andCursor:(NSNumber *)cursor handler:(TwitterResponseBlock)handler {
  [self callApiEndpoint:[NSString stringWithFormat:@"followers/ids.json?user_id=%@&cursor=%@",userId,cursor] andHandler:^(NSObject *responseObject, NSError *error){
    if(error){
      handler(nil,error);
    } else {
      NSDictionary *response = [NSDictionary dictionaryWithDictionary:(NSDictionary *)responseObject];
      NSNumber *nextCursor = [response objectForKey:@"next_cursor"];
      NSArray *allIds = [ids arrayByAddingObjectsFromArray:[response objectForKey:@"ids"]];
      if([nextCursor intValue] > 0){
        // more ids, need to recurse
        [self followerIdsForUser:userId withIds:allIds andCursor:nextCursor handler:handler];
      } else {
        // all done! call back with ids array
        handler(allIds,nil);
      }
    }
  }];
}

#pragma mark - users

+ (void) lookupUsersByIds:(NSArray *)ids handler:(TwitterResponseBlock)handler {
  [self lookupUsersByIds:ids withUsers:[NSArray array] handler:handler];
}

+ (void) lookupUsersByIds:(NSArray *)ids withUsers:(NSArray *)users handler:(TwitterResponseBlock)handler {
  // set up a range
  NSRange idsRange;
  idsRange.location = 0;
  // set the range to the end of the ids
  int rangeLength = (int)[ids count];
  // if we have too many ids, use the max (100)
  if((int)[ids count] > 100){
    rangeLength = 100;
  }
  idsRange.length = rangeLength;
  // get up to 100 users from the beginning of the array
  NSArray *lookupIds = [ids subarrayWithRange:idsRange];
  // set up the request params
  NSArray *paramKeys = [NSArray arrayWithObjects:@"user_id",@"include_entities",nil];
  NSArray *paramValues = [NSArray arrayWithObjects:[lookupIds componentsJoinedByString:@","],@"true", nil];
  NSDictionary *params = [NSDictionary dictionaryWithObjects:paramValues forKeys:paramKeys];
  // call the api
  [self callApiEndpoint:@"users/lookup.json" withParameters:params andHandler:^(NSArray *returnedUsers, NSError *error){
    // add returned users to users we were passed
    NSArray *newUsers = [users arrayByAddingObjectsFromArray:returnedUsers];
    // remove the ids we have just gotten from the ids array
    NSArray *nextIds = [ids subarrayWithRange:NSMakeRange(rangeLength, (int)[ids count] - rangeLength)];
    if((int)[nextIds count] > 0){
      // more users than we could get with this call - recurse
      [self lookupUsersByIds:nextIds withUsers:newUsers handler:handler];
    } else {
      // all done
      handler(newUsers,nil);
    }
  }];
}

#pragma mark - lists

+ (void) allListsForUser:(NSString *)userId withHandler:(TwitterResponseBlock)handler {
  [self callApiEndpoint:[NSString stringWithFormat:@"lists/all?user_id=%@",userId] andHandler:handler];
}

#pragma mark - call the api

+ (void) callApiEndpoint:(NSString *)urlFragment andHandler:(TwitterResponseBlock)handler {
  [self callApiEndpoint:urlFragment withMethod:SLRequestMethodGET andHandler:handler];
}

+ (void) callApiEndpoint:(NSString *)urlFragment withParameters:(NSDictionary *)parameters andHandler:(TwitterResponseBlock)handler {
  [self callApiEndpoint:urlFragment withParameters:parameters method:SLRequestMethodPOST andHandler:handler];
}

+ (void) callApiEndpoint:(NSString *)urlFragment withMethod:(SLRequestMethod)method andHandler:(TwitterResponseBlock)handler {
  [self callApiEndpoint:urlFragment withParameters:nil method:method andHandler:handler];
}

+ (void) callApiEndpoint:(NSString *)urlFragment withParameters:(NSDictionary *)parameters method:(SLRequestMethod)method andHandler:(TwitterResponseBlock)handler {
  FollowersAppDelegate *appDelegate = (id)[[NSApplication sharedApplication] delegate];
  NSURL *apiUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/1/%@",urlFragment]];
  SLRequest *followersRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:method URL:apiUrl parameters:parameters];
  [followersRequest setAccount:appDelegate.twitterAccount];
  [followersRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error){
    NSError *jsonError;
    NSObject *responseObject = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonError];
    //NSLog(@"Twitter response: %@, Error: %@, JSON error: %@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding],error,jsonError);
    if(jsonError){
      // invalid json
      handler(nil,jsonError);
    } else if(error){
      // we hit an error
      handler(nil,error);
    } else if([responseObject isKindOfClass:[NSDictionary class]] && [(NSDictionary *)responseObject objectForKey:@"errors"]){
      // return twitter errors as errors
      handler(nil,[(NSDictionary *)responseObject objectForKey:@"errors"]);
    } else {
      // good to go!
      handler(responseObject,nil);
    }
  }];
}

@end
