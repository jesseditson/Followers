//
//  FollowersLoginViewController.m
//  Followers
//
//  Created by Jesse Ditson on 7/25/12.
//  Copyright (c) 2012 Jesse Ditson. All rights reserved.
//

#import "FollowersLoginViewController.h"
#import "FollowersLoginView.h"
#import "NSView+FollowersExtensions.h"

@interface FollowersLoginViewController ()
@property (nonatomic, strong) FollowersLoginView *view;
@end

@implementation FollowersLoginViewController

- (id)init {
	self = [super init];
	if(self){
    // init code here
  }
  return self;
}

#pragma mark NSViewController

- (void)loadView {
  NSLog(@"Loading Login View");
	self.view = [FollowersLoginView followers_viewFromNib];
}

#pragma mark API

@dynamic view;

@end
