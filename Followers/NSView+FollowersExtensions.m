//
//  NSView+FollowersExtensions.m
//  Followers
//
//  Created by Jesse Ditson on 7/11/12.
//  Copyright (c) 2012 Jesse Ditson. All rights reserved.
//

#import "NSView+FollowersExtensions.h"

@implementation NSView (FollowersExtensions)

+ (id)followers_viewFromNib {
	return [self followers_viewFromNibNamed:NSStringFromClass(self)];
}

+ (id)followers_viewFromNibNamed:(NSString *)nibName {
	NSNib *nib = [[NSNib alloc] initWithNibNamed:nibName bundle:nil];
	NSArray *topLevelObjects = nil;
	BOOL success = [nib instantiateNibWithOwner:self topLevelObjects:&topLevelObjects];
	if(!success) return nil;
	
	NSView *view = nil;
	for(id topLevelObject in topLevelObjects) {
		if([topLevelObject isKindOfClass:self]) {
			view = topLevelObject;
			break;
		}
	}
	
	return view;
}

@end
