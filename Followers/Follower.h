//
//  Follower.h
//  Followers
//
//  Created by Jesse Ditson on 7/28/12.
//  Copyright (c) 2012 Jesse Ditson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Follower : NSManagedObject

@property (nonatomic, retain) NSNumber * owner_account;
@property (nonatomic, retain) NSNumber * contributors_enabled;
@property (nonatomic, retain) NSString * created_at;
@property (nonatomic, retain) NSNumber * favourites_count;
@property (nonatomic, retain) NSNumber * followers_count;
@property (nonatomic, retain) NSNumber * is_following;
@property (nonatomic, retain) NSNumber * is_friends;
@property (nonatomic, retain) NSNumber * friends_count;
@property (nonatomic, retain) NSString * full_json;
@property (nonatomic, retain) NSNumber * geo_enabled;
@property (nonatomic, retain) NSString * lang;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * notifications;
@property (nonatomic, retain) NSNumber * original;
@property (nonatomic, retain) NSString * profile_image_url;
@property (nonatomic, retain) NSNumber * protected;
@property (nonatomic, retain) NSString * screen_name;
@property (nonatomic, retain) NSNumber * statuses_count;
@property (nonatomic, retain) NSNumber * timestamp_followed;
@property (nonatomic, retain) NSNumber * timestamp_followed_me;
@property (nonatomic, retain) NSNumber * timestamp_unfollowed;
@property (nonatomic, retain) NSNumber * timestamp_unfollowed_me;
@property (nonatomic, retain) NSString * twitter_id;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * user_description;
@property (nonatomic, retain) NSNumber * utc_offset;
@property (nonatomic, retain) NSNumber * verified;
@property (nonatomic, retain) NSNumber * vip;
@property (nonatomic, retain) NSNumber * has_app;

@end
