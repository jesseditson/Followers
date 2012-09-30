//
//  FollowersVIPListViewController.m
//  Followers
//
//  Created by Jesse Ditson on 7/27/12.
//  Copyright (c) 2012 Jesse Ditson. All rights reserved.
//

#import "FollowersVIPListViewController.h"
#import "FollowersVIPListView.h"
#import "NSView+FollowersExtensions.h"
#import "FollowersUserState.h"
#import "Twitter.h"

@interface FollowersVIPListViewController ()
@property (nonatomic, strong) FollowersVIPListView *view;
@end

@implementation FollowersVIPListViewController

- (id)init {
	self = [super init];
	if(self){
    // init code here
  }
  return self;
}

#pragma mark NSViewController

- (void)loadView {
  NSLog(@"Loading VIP List View");
	self.view = [FollowersVIPListView followers_viewFromNib];
  NSString *userId = [FollowersUserState valueForKey:@"currentUsername"];
  [Twitter allListsForUser:userId withHandler:^(NSArray *lists, NSError *error){
    NSLog(@"got lists %@ and error %@",lists,error);
    [Twitter followersForUser:userId handler:^(NSArray *followers, NSError *error){
      __block NSMutableArray *users = [[NSMutableArray alloc] initWithArray:followers];
      [Twitter friendsForUser:userId handler:^(NSArray *friends,NSError *error){
        NSLog(@"got followers %@ and error %@",users,error);
        [users addObjectsFromArray:friends];
        [self.view populateWithUsers:users andLists:lists];
      }];
    }];
  }];
}

#pragma mark API

@dynamic view;

@end
