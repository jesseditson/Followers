//
//  FollowersUserState.h
//  Followers
//
//  Created by Jesse Ditson on 7/28/12.
//  Copyright (c) 2012 Jesse Ditson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FollowersUserState : NSObject

@property (nonatomic, retain) NSUserDefaults *config;
@property (nonatomic, retain) NSString *currentState;

- (void) setState:(NSString *)state toValue:(NSString *)value;

@end
