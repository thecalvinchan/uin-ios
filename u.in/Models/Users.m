//
//  Users.m
//  u.in
//
//  Created by Calvin on 7/16/14.
//  Copyright (c) 2014 Calvin Chan. All rights reserved.
//

#import "Users.h"

@implementation Users
- (instancetype)initWithDict: (NSDictionary *)dict {
    self = [super init];
    NSString *firstName = [dict objectForKey:@"firstName"];
    NSString *lastName = [dict objectForKey:@"lastName"];
    NSArray *phoneNumbers = [dict objectForKey:@"phoneNumbers"];
    NSString *username = [dict objectForKey:@"username"];
    if (firstName) self.firstName = firstName;
    if (lastName) self.lastName = lastName;
    if (phoneNumbers) self.phoneNumbers = phoneNumbers;
    if (username) self.username = username;
    return self;
}

- (NSString *)returnUserHash {
    if ([self.phoneNumbers count] > 0) {
        return [NSString stringWithFormat:@"%@ %@ %@",self.firstName,self.lastName,self.phoneNumbers[0] ];
    } else {
        return nil;
    }
}
- (NSDictionary *)returnDictRepresentation {
    NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
    if (self.firstName) [userDict setObject:self.firstName forKey:@"firstName"];
    if (self.lastName) [userDict setObject:self.lastName forKey:@"lastName"];
    if (self.phoneNumbers) [userDict setObject:self.phoneNumbers forKey:@"phoneNumbers"];
    if (self.username) [userDict setObject:self.username forKey:@"username"];
    return userDict;
}

@end
