//
//  FollowersVIPListView.m
//  Followers
//
//  Created by Jesse Ditson on 7/27/12.
//  Copyright (c) 2012 Jesse Ditson. All rights reserved.
//

#import "FollowersVIPListView.h"
#import "Twitter.h"
#import "FollowersUserState.h"

@implementation FollowersVIPListView

@synthesize vipTable, users;

@synthesize titleLabel;

- (void) awakeFromNib {
  appDelegate = (id)[[NSApplication sharedApplication] delegate];
}

- (void) populateWithUsers:(NSArray *)usersArray andLists:(NSArray *)listsArray {
  self.users = [[NSMutableArray alloc] initWithArray:usersArray];
  [titleLabel setStringValue:[NSString stringWithFormat:@"%lu users",[usersArray count]]];
  [self.vipTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

- (IBAction) pressedSaveButton:(id)sender {
  NSMutableArray *userIds = [[NSMutableArray alloc] init];
  int len = (int)[self.users count];
  for(int i=0;i<len;i++){
    [userIds addObject:[[self.users objectAtIndex:i] objectForKey:@"id"]];
  }
  NSString *userId = [FollowersUserState valueForKey:@"currentUsername"];
  [Twitter saveListForUser:userId withName:@"Followers_VIPs" withIds:userIds andHandler:^(NSDictionary *savedList, NSError *error){
    //TODO: handle error
    [appDelegate setVIPList:[savedList objectForKey:@"slug"]];
  }];
}

#pragma mark TableView Data Source
- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
  return [self.users count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
  // TODO: check if user is on a VIP list
  NSNumber *isVIP = [[self.users objectAtIndex:rowIndex] objectForKey:@"VIP"];
  if(isVIP == NULL) isVIP = [NSNumber numberWithBool:YES];
  return isVIP;
}

#pragma mark TableView Delegate
- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
  return 80.0;
}

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
  NSMutableDictionary *thisUser = [[NSMutableDictionary alloc] initWithDictionary:[self.users objectAtIndex:row]];
  NSNumber *isVIP = [thisUser objectForKey:@"VIP"];
  // TODO: actually set this on the user object
  if(![isVIP boolValue] || isVIP == NULL){
    [thisUser setObject:[NSNumber numberWithBool:YES] forKey:@"VIP"];
  } else {
    [thisUser setObject:[NSNumber numberWithBool:NO] forKey:@"VIP"];
  }
  [self.users replaceObjectAtIndex:row withObject:thisUser];
  [self.vipTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

- (void)tableView:(NSTableView *)aTableView willDisplayCell:(id)aCell forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
  if([[aTableColumn identifier] isEqualToString:@"users"]){
    NSDictionary *user = [self.users objectAtIndex:rowIndex];
    NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: [user objectForKey:@"profile_image_url"]]];
    [aCell setImage:[[NSImage alloc] initWithData:imageData]];
    [aCell setTitle:[user objectForKey:@"name"]];
    [aCell setSubtitle:[user objectForKey:@"description"]];
    [aCell setWraps:YES];
  } else {
    [aCell setTitle:@""];
  }
}

@end
