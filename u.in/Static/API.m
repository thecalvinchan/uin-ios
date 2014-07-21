//
//  API.m
//  u.in
//
//  Created by Calvin on 7/16/14.
//  Copyright (c) 2014 Calvin Chan. All rights reserved.
//

#import "API.h"
#import <Parse/Parse.h>
#import "../Models/Users.h"

@implementation API

+ (NSDictionary *)returnFriendsForCurrentUser {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *friends = [[NSMutableDictionary alloc] init];
    NSArray *hashlist = [defaults objectForKey:@"hash"];
    for (NSString *hash in hashlist) {
        Users *friend = [[Users alloc] initWithDict:[defaults objectForKey:hash]];
        [friends setObject:friend forKey:hash];
    }
    NSArray *parseFriends = [defaults objectForKey:@"parseFriends"];
    NSMutableDictionary *returnData = [[NSMutableDictionary alloc] init];
    [returnData setObject:friends forKey:@"contactsFriends"];
    if (parseFriends) {
        [returnData setObject:parseFriends forKey:@"parseFriends"];
    }
    return returnData;
}

+ (void)queryUpcomingEventsByCurrentUser:(id)observer :(SEL)callback {
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    [query whereKey:@"createdBy" equalTo:[PFUser currentUser]];
    [query includeKey:@"createdBy"];
    [query findObjectsInBackgroundWithTarget:observer selector:callback];
}

+ (void)queryUpcomingInvitationsForCurrentUser:(id)observer :(SEL)callback {
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    [query whereKey:@"guestUsers" equalTo:[PFUser currentUser]];
    [query includeKey:@"createdBy"];
    [query findObjectsInBackgroundWithTarget:observer selector:callback];
}

+ (void)addFriendForCurrentUser:(NSString *)friendUsername :(id)observer :(SEL)callback {
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:friendUsername];
    [query getFirstObjectInBackgroundWithTarget:observer selector:callback];
}

@end
