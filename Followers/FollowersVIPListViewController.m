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
  [Twitter followersForUser:@"98531887" handler:^(NSArray *users, NSError *error){
    NSLog(@"got followers %@ and error %@",users,error);
  }];
}

#pragma mark API

@dynamic view;

@end
