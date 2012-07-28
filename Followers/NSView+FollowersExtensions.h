//
//  NSView+FollowersExtensions.h
//  Followers
//
//  Created by Jesse Ditson on 7/11/12.
//  Copyright (c) 2012 Jesse Ditson. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSView (FollowersExtensions)

+ (id)followers_viewFromNib;
+ (id)followers_viewFromNibNamed:(NSString *)nibName;

@end
