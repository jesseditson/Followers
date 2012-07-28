//
//  FollowersMainWindowController.m
//  Followers
//
//  Created by Jesse Ditson on 7/25/12.
//  Copyright (c) 2012 Jesse Ditson. All rights reserved.
//

#import "FollowersAppDelegate.h"
#import "FollowersMainWindowController.h"
#import "FollowersLoginViewController.h"
#import "FollowersVIPListViewController.h"

@interface FollowersMainWindowController ()
@property (nonatomic, strong) NSViewController *currentViewController;
@property (nonatomic, strong) FollowersAppDelegate *appDelegate;
@end

@implementation FollowersMainWindowController
@synthesize appDelegate;

- (id)init {
    self = [super initWithWindowNibName:NSStringFromClass([self class]) owner:self];
    if (self) {
      self.appDelegate = (id)[[NSApplication sharedApplication] delegate];
    }
    return self;
}

- (void)windowDidLoad {
  [super windowDidLoad];
  [self refreshState];
}

- (void) refreshState {
  NSString *state = [self.appDelegate getUserState];
  if([state isEqualToString:@"normal"]){
    // show main screen
  } else if([state isEqualToString:@"vipList"]){
    FollowersVIPListViewController *vipListViewController = [[FollowersVIPListViewController alloc] init];
    [self setCurrentViewController:(NSViewController *)vipListViewController];
  } else {
    // logged out
    FollowersLoginViewController *loginViewController = [[FollowersLoginViewController alloc] init];
    self.currentViewController = loginViewController;
  }
}

#pragma mark API

@synthesize currentViewController;

- (void)setCurrentViewController:(NSViewController *)vc {
	if(currentViewController == vc) return;
  NSLog(@"switching view controller");
	
  currentViewController = vc;
	[self.window setContentView:currentViewController.view];
}
@end
