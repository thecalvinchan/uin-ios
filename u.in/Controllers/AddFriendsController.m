//
//  AddFriendsController.m
//  u.in
//
//  Created by Calvin on 7/19/14.
//  Copyright (c) 2014 Calvin Chan. All rights reserved.
//

#import "AddFriendsController.h"
#import "../Models/Users.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface AddFriendsController()
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@end

@implementation AddFriendsController
- (IBAction)addFriendFromUsername:(id)sender {
}

- (IBAction)addFriendFromContacts:(id)sender {
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)addContactToFriends:(ABRecordRef)person {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *hashlist = [[defaults objectForKey:@"hash"] mutableCopy];
    if ([hashlist count] <=0) {
        hashlist = [[NSMutableArray alloc] init];
    }

    
    NSString* firstName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString* lastName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
    
    NSString* phone = nil;
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person,
                                                     kABPersonPhoneProperty);
    if (ABMultiValueGetCount(phoneNumbers) > 0) {
        phone = (__bridge_transfer NSString*)
        ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
    } else {
        phone = @"[None]";
    }
    
    Users *user = [[Users alloc] init];
    user.firstName = firstName;
    user.lastName = lastName;
    NSMutableArray *numbers = [[NSMutableArray alloc] init];
    for (int i=0; i<ABMultiValueGetCount(phoneNumbers); i++) {
        [numbers addObject:(__bridge_transfer NSString*)ABMultiValueCopyValueAtIndex(phoneNumbers, i)];
    }
    user.phoneNumbers = numbers;
    NSString *hash = [user returnUserHash];
    [defaults setObject:[user returnDictRepresentation] forKey:hash];
    if (![hashlist containsObject:hash]) {
        [hashlist addObject:hash];
    }
    [defaults setObject:(NSArray *)hashlist forKey:@"hash"];
    [defaults synchronize];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                    message:[NSString stringWithFormat:@"You've added %@ to your friends!", firstName]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    CFRelease(phoneNumbers);
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    [self addContactToFriends:person];
    [self dismissViewControllerAnimated:NO completion:nil];
    return NO;
}

- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier {
    return NO;
}
@end
