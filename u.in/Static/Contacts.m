//
//  Contacts.m
//  u.in
//
//  Created by Calvin on 7/16/14.
//  Copyright (c) 2014 Calvin Chan. All rights reserved.
//

#import "Contacts.h"
#import "../Models/Users.h"
#import <RHAddressBook/AddressBook.h>

@implementation Contacts
+ (NSDictionary *)returnContactsForCurrentUser {
    NSMutableDictionary *contacts = [[NSMutableDictionary alloc] init];
    RHAddressBook *ab = [[RHAddressBook alloc] init];
    
    if ([RHAddressBook authorizationStatus] == RHAuthorizationStatusNotDetermined){
        //request authorization
        [ab requestAuthorizationWithCompletion:^(bool granted, NSError *error) {
            NSLog(@"Request auth to read address book");
        }];
    }
    
    NSArray *allPeopleSorted = [ab peopleOrderedByUsersPreference];
    for (RHPerson *person in allPeopleSorted) {
        Users *user = [[Users alloc] init];
        user.firstName = [person firstName];
        user.lastName = [person lastName];
        RHMultiValue *addressbook = [person phoneNumbers];
        NSMutableArray *numbers = [[NSMutableArray alloc] init];
        for (int i=0; i<[addressbook count]; i++) {
            [numbers addObject:[addressbook valueAtIndex:i]];
        }
        user.phoneNumbers = numbers;
        NSString *hash = [user returnUserHash];
        if (hash) {
            [contacts setObject:user forKey:hash];
        }
    }
    return contacts;
}
@end
