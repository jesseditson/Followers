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

+ (void) followersForUser:(NSString *)screenname handler:(TwitterResponseBlock)handler {
  [self followerIdsForUser:screenname handler:^(NSArray *followerIds, NSError *error){
    NSLog(@"Got follower ids: %@",followerIds);
    [self lookupUsersByIds:followerIds handler:^(NSArray *users, NSError *error){
      // TODO: handle errors
      handler(users,nil);
    }];
  }];
}

+ (void) followerIdsForUser:(NSString *)screenname handler:(TwitterResponseBlock)handler {
  // get all the follower ids
  [self followerIdsForUser:screenname withIds:[NSArray array] andCursor:[NSNumber numberWithInt:-1] handler:handler];
}

+ (void) followerIdsForUser:(NSString *)screenname withIds:(NSArray *)ids andCursor:(NSNumber *)cursor handler:(TwitterResponseBlock)handler {
  [self callApiEndpoint:[NSString stringWithFormat:@"followers/ids.json?screen_name=%@&cursor=%@",screenname,cursor] andHandler:^(NSObject *responseObject, NSError *error){
    if(error){
      handler(nil,error);
    } else {
      NSDictionary *response = [NSDictionary dictionaryWithDictionary:(NSDictionary *)responseObject];
      NSNumber *nextCursor = [response objectForKey:@"next_cursor"];
      NSArray *allIds = [ids arrayByAddingObjectsFromArray:[response objectForKey:@"ids"]];
      if([nextCursor intValue] > 0){
        // more ids, need to recurse
        [self followerIdsForUser:screenname withIds:allIds andCursor:nextCursor handler:handler];
      } else {
        // all done! call back with ids array
        handler(allIds,nil);
      }
    }
  }];
}

+ (void) friendsForUser:(NSString *)screenname handler:(TwitterResponseBlock)handler {
  [self friendIdsForUser:screenname handler:^(NSArray *followerIds, NSError *error){
    NSLog(@"Got follower ids: %@",followerIds);
    [self lookupUsersByIds:followerIds handler:^(NSArray *users, NSError *error){
      // TODO: handle errors
      handler(users,nil);
    }];
  }];
}

+ (void) friendIdsForUser:(NSString *)screenname handler:(TwitterResponseBlock)handler {
  // get all the follower ids
  [self friendIdsForUser:screenname withIds:[NSArray array] andCursor:[NSNumber numberWithInt:-1] handler:handler];
}

+ (void) friendIdsForUser:(NSString *)screenname withIds:(NSArray *)ids andCursor:(NSNumber *)cursor handler:(TwitterResponseBlock)handler {
  [self callApiEndpoint:[NSString stringWithFormat:@"friends/ids.json?screen_name=%@&cursor=%@",screenname,cursor] andHandler:^(NSObject *responseObject, NSError *error){
    if(error){
      handler(nil,error);
    } else {
      NSDictionary *response = [NSDictionary dictionaryWithDictionary:(NSDictionary *)responseObject];
      NSNumber *nextCursor = [response objectForKey:@"next_cursor"];
      NSArray *allIds = [ids arrayByAddingObjectsFromArray:[response objectForKey:@"ids"]];
      if([nextCursor intValue] > 0){
        // more ids, need to recurse
        [self friendIdsForUser:screenname withIds:allIds andCursor:nextCursor handler:handler];
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

+ (void) allListsForUser:(NSString *)username withHandler:(TwitterResponseBlock)handler {
  NSLog(@"looking up lists for user %@",username);
  [self callApiEndpoint:[NSString stringWithFormat:@"lists/all.json?screen_name=%@",username] andHandler:handler];
}

+ (void) updateListForUser:(NSString *)username withName:(NSString *)listName withIds:(NSArray *)listIds andHandler:(TwitterResponseBlock)handler {
  int listCount = (int)[listIds count];
  if(listCount > 100){
    // split the request up into multiple requests.
    NSMutableArray *chunks = [[NSMutableArray alloc] init];
    for(int i=0;i<listCount;i++){
      int chunkIndex = floor(i/100);
      if(chunkIndex >= [chunks count]){
        [chunks addObject:[[NSMutableArray alloc] init]];
      }
      [[chunks objectAtIndex:chunkIndex] addObject:[listIds objectAtIndex:i]];
    }
    __block int completeChunks = 0;
    int chunkLen = (int)[chunks count];
    for(int c=0;c<chunkLen;c++){
      [self updateListForUser:username withName:listName withIds:listIds andHandler:^(NSDictionary *listInfo, NSError *error){
        int thisNum = completeChunks++;
        NSLog(@"update %d of %d complete.",thisNum,completeChunks);
        if(completeChunks == chunkLen){
          NSLog(@"done updating list.");
          handler(listInfo,error);
        }
      }];
    }
  } else {
    NSString *userIds = [listIds componentsJoinedByString:@","];
    NSArray *keys = [NSArray arrayWithObjects:@"slug", @"user_id", @"owner_screen_name", nil];
    NSArray *values = [NSArray arrayWithObjects:listName, userIds, username, nil];
    NSDictionary *saveParams = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    NSLog(@"updating list with params: %@",saveParams);
    [self callApiEndpoint:@"lists/members/create_all.json" withParameters:saveParams andHandler:^(NSDictionary *listInfo,NSError *error){
      NSLog(@"list updated with response: %@ and error %@.",listInfo,error);
      handler(listInfo,error);
    }];
  }
}

+ (void) createListForUser:(NSString *)username withName:(NSString *)listName withIds:(NSArray *)listIds andHandler:(TwitterResponseBlock)handler {
  NSArray *keys = [NSArray arrayWithObjects:@"name",@"mode",@"description", nil];
  NSArray *values = [NSArray arrayWithObjects:listName,@"private",@"List created with Followers - http://followersapp.com", nil];
  NSDictionary *createParams = [NSDictionary dictionaryWithObjects:values forKeys:keys];
  [self callApiEndpoint:@"lists/create.json" withParameters:createParams andHandler:^(NSDictionary *listInfo, NSError *error){
    // TODO: handle error;
    NSString *savedListName = [listInfo objectForKey:@"slug"];
    [self updateListForUser:username withName:savedListName withIds:listIds andHandler:handler];
  }];
}

+ (void) saveListForUser:(NSString *)username withName:(NSString *)listName withIds:(NSArray *)listIds andHandler:(TwitterResponseBlock)handler {
  // check if we already have this list.
  [self getListForUser:username withName:listName andHandler:^(NSMutableArray *previousList, NSError *error){
    // TODO: handle errors
    NSMutableArray *listUsers = [[NSMutableArray alloc] init];
    if(previousList != NULL){
      int len = (int)[previousList count];
      for(int u=0;u<len;u++){
        [listUsers addObject:[previousList objectAtIndex:u]];
      }
    }
    [listUsers addObjectsFromArray:listIds];
    if((int)[listUsers count] > 500){
      // TODO: continue and just save up to 500 or auto create a new list.
      NSLog(@"ERROR: lists can only have up to 500 users. not saving list.");
      handler(nil,nil);
    } else {
      if(previousList == NULL){
        // create the list
        [self createListForUser:username withName:listName withIds:listUsers andHandler:handler];
      } else {
        // update the list
        [self updateListForUser:username withName:listName withIds:listUsers andHandler:handler];
      }
    }
  }];
  
  /* TODO: will eventually need to support lists with more than 500 users.
  // Note that only 20 lists per account can be created. May want to move lists to a separate service.
  // probably will look something like this:
  NSLog(@"Saving list for user %@ with ids %@",username, listIds);
  NSMutableArray *userBlocks = [[NSMutableArray alloc] init];
  int block;
  int len = (int)[listIds count];
  for(int o=0;o<len;o++){
    block = floor(o / 500);
    [[userBlocks objectAtIndex:block] addObject:[listIds objectAtIndex:o]];
  }
  int bLen = (int)[userBlocks count];
  for(int i=0;i<bLen;i++){
    NSString *userIds = [[userBlocks objectAtIndex:i] componentsJoinedByString:@","];
    NSArray *keys = [NSArray arrayWithObjects:@"screen_name", nil];
    NSArray *values = [NSArray arrayWithObjects:userIds, nil];
    NSDictionary *saveParams = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    
    //[self callApiEndpoint:[NSString stringWithFormat:@"lists/members/create_all.json"] withParameters:saveParams andHandler:handler];
  }
  */
}

+ (void) getListForUser:(NSString *)username withName:(NSString *)listName andHandler:(TwitterResponseBlock)handler {
  [self getListForUser:username withName:listName andHandler:handler withCursor:[NSNumber numberWithDouble:-1]];
}

+ (void) getListForUser:(NSString *)username withName:(NSString *)listName andHandler:(TwitterResponseBlock)handler withCursor:(NSNumber *)cursor {
  [self getListForUser:username withName:listName andHandler:handler withCursor:cursor andPreviousList:[[NSMutableArray alloc] init]];
}

+ (void) getListForUser:(NSString *)username withName:(NSString *)listName andHandler:(TwitterResponseBlock)handler withCursor:(NSNumber *)cursor andPreviousList:(NSMutableArray *)previousList {
  [self callApiEndpoint:[NSString stringWithFormat:@"lists/members.json?slug=%@&owner_screen_name=%@&cursor=%@",listName,username,cursor] andHandler:^(NSDictionary *listInfo, NSError *error){
    NSLog(@"info returned: %@",listInfo);
    if(listInfo == NULL){
      handler(listInfo,nil);
    } else {
      NSNumber *nextCursor = [listInfo objectForKey:@"next_cursor"];
      [previousList addObjectsFromArray:[listInfo objectForKey:@"users"]];
      if([nextCursor intValue] < 0){
        // more items in list. recurse.
        [self getListForUser:username withName:listName andHandler:handler withCursor:nextCursor andPreviousList:previousList];
      } else {
        // done getting list. call back.
        handler(previousList,nil);
      }
    }
  }];
}

#pragma mark - account

+ (void) currentAccount:(TwitterResponseBlock)handler {
  [self callApiEndpoint:@"account/verify_credentials.json" andHandler:handler];
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
    NSLog(@"Twitter response: for endpoint %@: %@, Error: %@, JSON error: %@",urlFragment, [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding],error,jsonError);
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
