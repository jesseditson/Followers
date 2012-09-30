//
//  FollowersAppDelegate.h
//  Followers
//
//  Created by Jesse Ditson on 7/25/12.
//  Copyright (c) 2012 Jesse Ditson. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Accounts/Accounts.h>
#import "FollowersUserState.h"

@interface FollowersAppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, strong) FollowersUserState *_userState;

@property (assign) IBOutlet NSWindow *window;
@property (retain) ACAccountStore *twitterAccountStore;
@property (retain) ACAccount *twitterAccount;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)saveAction:(id)sender;

- (void)loggedIn;
- (void)setVIPList:(NSString *)vipListSlug;

- (NSString *)getUserState;

@end
