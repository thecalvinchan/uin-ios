//
//  Users.m
//  u.in
//
//  Created by Calvin on 7/16/14.
//  Copyright (c) 2014 Calvin Chan. All rights reserved.
//

#import "Users.h"

@implementation Users
- (NSString *)returnUserHash {
    if ([self.phoneNumbers count] > 0) {
        return [NSString stringWithFormat:@"%@ %@ %@",self.firstName,self.lastName,self.phoneNumbers[0] ];
    } else {
        return nil;
    }
}
@end
