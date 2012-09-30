//
//  FollowersList.h
//  Followers
//
//  Created by Jesse Ditson on 7/28/12.
//  Copyright (c) 2012 Jesse Ditson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TwitterList;

@interface FollowersList : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *twitterLists;
@end

@interface FollowersList (CoreDataGeneratedAccessors)

- (void)addTwitterListsObject:(TwitterList *)value;
- (void)removeTwitterListsObject:(TwitterList *)value;
- (void)addTwitterLists:(NSSet *)values;
- (void)removeTwitterLists:(NSSet *)values;

@end
