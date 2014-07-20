//
//  API.h
//  u.in
//
//  Created by Calvin on 7/16/14.
//  Copyright (c) 2014 Calvin Chan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface API : NSObject
+ (NSDictionary *)returnFriendsForCurrentUser;
+ (void)queryUpcomingEventsByCurrentUser:(id)observer :(SEL)callback;
+ (void)queryUpcomingInvitationsForCurrentUser:(id)observer :(SEL)callback;
@end
