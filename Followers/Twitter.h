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

+ (void) followersForUser:(NSString *)screenname handler:(TwitterResponseBlock)handler;
+ (void) followerIdsForUser:(NSString *)screenname handler:(TwitterResponseBlock)handler;
+ (void) followerIdsForUser:(NSString *)screenname withIds:(NSArray *)ids andCursor:(NSNumber *)cursor handler:(TwitterResponseBlock)handler;
+ (void) friendsForUser:(NSString *)screenname handler:(TwitterResponseBlock)handler;
+ (void) friendIdsForUser:(NSString *)screenname handler:(TwitterResponseBlock)handler;
+ (void) friendIdsForUser:(NSString *)screenname withIds:(NSArray *)ids andCursor:(NSNumber *)cursor handler:(TwitterResponseBlock)handler;

#pragma mark - users

+ (void) lookupUsersByIds:(NSArray *)ids handler:(TwitterResponseBlock)handler;
+ (void) lookupUsersByIds:(NSArray *)ids withUsers:(NSArray *)users handler:(TwitterResponseBlock)handler;

#pragma mark - lists

+ (void) allListsForUser:(NSString *)screenname withHandler:(TwitterResponseBlock)handler;
+ (void) saveListForUser:(NSString *)username withName:(NSString *)listName withIds:(NSArray *)listIds andHandler:(TwitterResponseBlock)handler;
+ (void) updateListForUser:(NSString *)username withName:(NSString *)listName withIds:(NSArray *)listIds andHandler:(TwitterResponseBlock)handler;
+ (void) createListForUser:(NSString *)username withName:(NSString *)listName withIds:(NSArray *)listIds andHandler:(TwitterResponseBlock)handler;
+ (void) getListForUser:(NSString *)username withName:(NSString *)listName andHandler:(TwitterResponseBlock)handler;

#pragma mark - account

+ (void) currentAccount:(TwitterResponseBlock)handler;

#pragma mark - api endpoint methods

+ (void) callApiEndpoint:(NSString *)urlFragment andHandler:(TwitterResponseBlock)handler;
+ (void) callApiEndpoint:(NSString *)urlFragment withParameters:(NSDictionary *)parameters andHandler:(TwitterResponseBlock)handler;
+ (void) callApiEndpoint:(NSString *)urlFragment withMethod:(SLRequestMethod)method andHandler:(TwitterResponseBlock)handler;
+ (void) callApiEndpoint:(NSString *)urlFragment withParameters:(NSDictionary *)parameters method:(SLRequestMethod)method andHandler:(TwitterResponseBlock)handler;

@end
