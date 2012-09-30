//
//  FollowersVIPListCell.h
//  Followers
//
//  Created by Jesse Ditson on 9/29/12.
//  Copyright (c) 2012 Jesse Ditson. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FollowersVIPListCell : NSTextFieldCell {
  @private
    NSImage *image;
    NSString *subtitle;
}

@property (readwrite, retain) NSImage *image;
@property (readwrite, copy) NSString *subtitle;

@end
