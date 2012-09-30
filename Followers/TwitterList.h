//
//  TwitterList.h
//  Followers
//
//  Created by Jesse Ditson on 7/28/12.
//  Copyright (c) 2012 Jesse Ditson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TwitterList : NSManagedObject

@property (nonatomic, retain) NSString * owner_account;
@property (nonatomic, retain) NSString * id_str;
@property (nonatomic, retain) NSNumber * following;
@property (nonatomic, retain) NSNumber * subscriber_count;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * full_name;
@property (nonatomic, retain) NSString * mode;
@property (nonatomic, retain) NSString * list_description;
@property (nonatomic, retain) NSString * created_at;
@property (nonatomic, retain) NSString * uri;
@property (nonatomic, retain) NSNumber * member_count;
@property (nonatomic, retain) NSNumber * list_id;
@property (nonatomic, retain) NSString * slug;
@property (nonatomic, retain) NSManagedObject *followersList;

@end
