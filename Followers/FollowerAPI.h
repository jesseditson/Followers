//
//  FollowerAPI.h
//  Followers
//
//  Created by Jesse Ditson on 7/28/12.
//  Copyright (c) 2012 Jesse Ditson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Follower.h"

@interface FollowerAPI : NSObject

+ (NSManagedObjectContext *) getFollowerManagedObjectContext;
+ (BOOL) createFollower:(NSDictionary *)aFollower asVIP:(BOOL)isVIP asOriginal:(BOOL)isOriginal;
+ (NSArray *) loadSavedFollowers;
+ (NSArray *) findFollowersWithPredicate:(NSPredicate *)predicate;
+ (BOOL) updateKey:(NSString *)keyName forFollowerId:(NSString *)twitterid toStringValue:(NSString *)value;
+ (BOOL) updateKey:(NSString *)keyName forFollowerId:(NSString *)twitterid toBOOLValue:(BOOL)value;
+ (BOOL) updateKey:(NSString *)keyName forFollowerId:(NSString *)twitterid toNumberValue:(NSNumber *)value;
+ (BOOL) saveFollower:(Follower *)theFollower;
+ (Follower *) findFollowerWithId:(NSString *)twitterid;
+ (NSString *)defaultString:(NSString *)value;
+ (NSNumber *)defaultNumber:(NSNumber *)value;

@end
