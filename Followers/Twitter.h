//
//  Twitter.h
//  Followers
//
//  Created by Jesse Ditson on 7/27/12.
//  Copyright (c) 2012 Jesse Ditson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Social/Social.h>

@interface Twitter : NSObject

typedef void (^ TwitterResponseBlock)(id,NSError *error);

#pragma mark - friends & followers

+ (void) followersForUser:(NSString *)userId handler:(TwitterResponseBlock)handler;

+ (void) followerIdsForUser:(NSString *)userId handler:(TwitterResponseBlock)handler;
+ (void) followerIdsForUser:(NSString *)userId withIds:(NSArray *)ids andCursor:(NSNumber *)cursor handler:(TwitterResponseBlock)handler;

#pragma mark - users

+ (void) lookupUsersByIds:(NSArray *)ids handler:(TwitterResponseBlock)handler;
+ (void) lookupUsersByIds:(NSArray *)ids withUsers:(NSArray *)users handler:(TwitterResponseBlock)handler;

#pragma mark - api endpoint methods

+ (void) callApiEndpoint:(NSString *)urlFragment andHandler:(TwitterResponseBlock)handler;
+ (void) callApiEndpoint:(NSString *)urlFragment withParameters:(NSDictionary *)parameters andHandler:(TwitterResponseBlock)handler;
+ (void) callApiEndpoint:(NSString *)urlFragment withMethod:(SLRequestMethod)method andHandler:(TwitterResponseBlock)handler;
+ (void) callApiEndpoint:(NSString *)urlFragment withParameters:(NSDictionary *)parameters method:(SLRequestMethod)method andHandler:(TwitterResponseBlock)handler;

#pragma mark - core data

+ (NSManagedObjectContext *) getFollowerManagedObjectContext;
+ (BOOL) createFollower:(NSDictionary *)aFollower asVIP:(BOOL)isVIP asOriginal:(BOOL)isOriginal;
+ (NSString *)defaultString:(NSString *)value;
+ (NSNumber *)defaultNumber:(NSNumber *)value;

@end
