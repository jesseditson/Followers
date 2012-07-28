//
//  FollowerAPI.m
//  Followers
//
//  Created by Jesse Ditson on 7/28/12.
//  Copyright (c) 2012 Jesse Ditson. All rights reserved.
//

#import "FollowerAPI.h"
#import "FollowersAppDelegate.h"

@implementation FollowerAPI

+ (NSManagedObjectContext *) getFollowerManagedObjectContext {
  FollowersAppDelegate *appDelegate = (id)[[NSApplication sharedApplication] delegate];
  return [appDelegate managedObjectContext];
}

+ (BOOL) createFollower:(NSDictionary *)aFollower asVIP:(BOOL)isVIP asOriginal:(BOOL)isOriginal {
  NSManagedObjectContext *managedObjectContext = [self getFollowerManagedObjectContext];
  Follower *follower = (Follower *)[NSEntityDescription insertNewObjectForEntityForName:@"Follower" inManagedObjectContext:managedObjectContext];
  NSString *twitterId = [NSString stringWithFormat:@"%@",[aFollower objectForKey:@"id"]];
  follower.twitter_id = twitterId;
  follower.screen_name = [self defaultString:[aFollower objectForKey:@"screen_name"]];
  follower.is_following = [self defaultNumber:[aFollower objectForKey:@"following"]];
  follower.is_friends = [self defaultNumber:[aFollower objectForKey:@"following_me"]];
  follower.statuses_count = [self defaultNumber:[aFollower objectForKey:@"statuses_count"]];
  follower.friends_count = [self defaultNumber:[aFollower objectForKey:@"friends_count"]];
  follower.user_description = [self defaultString:[aFollower objectForKey:@"user_description"]];
  follower.notifications = [self defaultNumber:[aFollower objectForKey:@"notifications"]];
  follower.geo_enabled = [self defaultNumber:[aFollower objectForKey:@"geo_enabled"]];
  follower.verified = [self defaultNumber:[aFollower objectForKey:@"verified"]];
  follower.followers_count = [self defaultNumber:[aFollower objectForKey:@"followers_count"]];
  follower.protected = [self defaultNumber:[aFollower objectForKey:@"protected"]];
  follower.utc_offset = [self defaultNumber:[aFollower objectForKey:@"utc_offset"]];
  follower.lang = [self defaultString:[aFollower objectForKey:@"lang"]];
  follower.contributors_enabled = [self defaultNumber:[aFollower objectForKey:@"contributors_enabled"]];
  follower.url = [self defaultString:[aFollower objectForKey:@"url"]];
  follower.favourites_count = [self defaultNumber:[aFollower objectForKey:@"favourites_count"]];
  follower.created_at = [self defaultString:[aFollower objectForKey:@"created_at"]];
  follower.profile_image_url = [self defaultString:[aFollower objectForKey:@"profile_image_url"]];
  follower.location = [self defaultString:[aFollower objectForKey:@"location"]];
  follower.name = [self defaultString:[aFollower objectForKey:@"name"]];
  follower.vip = [NSNumber numberWithBool:isVIP];
  follower.original = [NSNumber numberWithBool:isOriginal];
  NSError *jsonError;
  follower.full_json = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:aFollower options:0 error:&jsonError] encoding:NSUTF8StringEncoding];
  // TODO: handle jsonError?
  NSError *error;
  if(![managedObjectContext save:&error]){
    //TODO: Item could not be saved. Bail out or crash or something.
    NSLog(@"Failed to save Follower with error: %@",error);
    return NO;
  } else {
    return YES;
  }
}

+ (NSArray *) findFollowersWithPredicate:(NSPredicate *)predicate {
  NSManagedObjectContext *managedObjectContext = [self getFollowerManagedObjectContext];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Follower" inManagedObjectContext:managedObjectContext];
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  [request setEntity:entity];
  
  [request setPredicate:predicate];
  
  // Define how we will sort the records
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"twitter_id" ascending:YES];
  NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
  [request setSortDescriptors:sortDescriptors];
  
  // Fetch the records and handle an error  
  NSError *error;  
  NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
  NSMutableArray *foundFollowers = [NSMutableArray array];
  if (!mutableFetchResults) {
    // Handle the error.
    // TODO: bail out, crash, freak out in general
    NSLog(@"Error loading followers with predicate %@",[predicate description]);
  } else {
    foundFollowers = mutableFetchResults;
  }
  // return the live (saveable) objects
  return foundFollowers;
}

+ (BOOL) updateKey:(NSString *)keyName forFollowerId:(NSString *)twitterid toStringValue:(NSString *)value {
  Follower *theFollower = [self findFollowerWithId:twitterid];
  [theFollower setValue:value forKey:keyName];
  return [self saveFollower:theFollower];
}
+ (BOOL) updateKey:(NSString *)keyName forFollowerId:(NSString *)twitterid toBOOLValue:(BOOL)value {
  Follower *theFollower = [self findFollowerWithId:twitterid];
  [theFollower setValue:[NSNumber numberWithBool:value] forKey:keyName];
  return [self saveFollower:theFollower];
}
+ (BOOL) updateKey:(NSString *)keyName forFollowerId:(NSString *)twitterid toNumberValue:(NSNumber *)value {
  Follower *theFollower = [self findFollowerWithId:twitterid];
  [theFollower setValue:value forKey:keyName];
  return [self saveFollower:theFollower];
}

+ (BOOL) saveFollower:(Follower *)theFollower {
  NSError *error;
  [theFollower.managedObjectContext save:&error];
  if(error){
    NSLog(@"Error saving: %@",error.localizedDescription);
    return NO;
  } else {
    NSLog(@"successfully saved %@",[theFollower valueForKey:@"twitter_id"]);
    return YES;
  }
}

+ (Follower *) findFollowerWithId:(NSString *)twitterid {
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",@"twitter_id",twitterid];
  NSArray *results = [self findFollowersWithPredicate:predicate];
  if([results count] > 0){
     return [results objectAtIndex:0];
  } else {
    return nil;
  }
}

+ (NSArray *) loadSavedFollowers {
  NSLog(@"started loading current followers");
  NSManagedObjectContext *managedObjectContext = [self getFollowerManagedObjectContext];
  // load current users from coreData
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Follower" inManagedObjectContext:managedObjectContext];
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  [request setEntity:entity];
  
  // Define how we will sort the records
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"twitter_id" ascending:YES];
  NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
  [request setSortDescriptors:sortDescriptors];
  
  // Fetch the records and handle an error  
  NSError *error;  
  NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
  if (!mutableFetchResults) {  
    // Handle the error.
    // TODO: bail out, crash, freak out in general
    NSLog(@"Error loading current followers with error %@",error);
    return nil;
  } else {
    NSArray *foundFollowers = [NSArray arrayWithArray:mutableFetchResults];
    NSMutableArray *followerDictionaries = [NSMutableArray array];
    // convert followers to dictionaries
    for(Follower *follower in foundFollowers){
      NSArray *keys = [[[follower entity] attributesByName] allKeys];
      NSDictionary *dict = [follower dictionaryWithValuesForKeys:keys];
      [followerDictionaries addObject:dict];
    }
    NSLog(@"finished loading current followers");
    return followerDictionaries;
  }
}

+ (NSString *)defaultString:(NSString *)value {
  if(value == (id)[NSNull null] || value.length == 0){
    return @"";
  } else {
    return value;
  }
}
+ (NSNumber *)defaultNumber:(NSNumber *)value {
  if(value == (id)[NSNull null]){
    return 0;
  } else {
    return value;
  }
}

@end
