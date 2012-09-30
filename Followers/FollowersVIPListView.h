//
//  FollowersVIPListView.h
//  Followers
//
//  Created by Jesse Ditson on 7/27/12.
//  Copyright (c) 2012 Jesse Ditson. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FollowersAppDelegate.h"

@interface FollowersVIPListView : NSView <NSTableViewDelegate> {
  IBOutlet NSTableView *vipTable;
  NSMutableArray *users;
  FollowersAppDelegate *appDelegate;
}

@property (assign) IBOutlet NSTextField *titleLabel;
@property (retain) IBOutlet NSTableView *vipTable;
@property (retain) NSMutableArray *users;

- (IBAction) pressedSaveButton:(id)sender;

- (void) populateWithUsers:(NSArray *)usersArray andLists:(NSArray *)listsArray;

@end
