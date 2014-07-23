//
//  AddFriendsController.m
//  u.in
//
//  Created by Calvin on 7/19/14.
//  Copyright (c) 2014 Calvin Chan. All rights reserved.
//

#import "AddFriendsController.h"
#import <Parse/Parse.h>
#import "../Models/Users.h"
#import "../Static/API.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface AddFriendsController()
@property (strong, nonatomic) IBOutlet UITextField *usernameField;

@property (nonatomic, assign) id currentResponder;
@end

@implementation AddFriendsController

- (void)viewDidLoad {
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:singleTap];
    
    [super viewDidLoad];
}

- (void)addParseFriendFromUsernameCallback:(PFObject *)friend :(NSError *)err {
    if (err) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Errpr"
                                                        message:[NSString stringWithFormat:@"Could not find friend with that username!"]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    PFObject *user = [PFUser currentUser];
    PFRelation *relation = [user relationForKey:@"friends"];
    [relation addObject:friend];
    [user saveInBackground];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *parseFriends = [[defaults objectForKey:@"parseFriends"] mutableCopy];
    if (!parseFriends) {
        parseFriends = [[NSMutableArray alloc] init];
    }
    NSString *friendUsername = [friend objectForKey:@"username"];
    [parseFriends addObject:friendUsername];
    [defaults setObject:parseFriends forKey:@"parseFriends"];
    [defaults synchronize];
    dispatch_async(dispatch_get_main_queue(), ^(void){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                        message:[NSString stringWithFormat:@"You've added %@ to your friends!", friendUsername]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    });
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
    if (hash) {
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
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[NSString stringWithFormat:@"It seems like the contact information for %@ is incomplete.", firstName]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    [self.currentResponder resignFirstResponder];
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

- (IBAction)addFriendFromUsername:(id)sender {
    NSString *username = self.usernameField.text;
    [API addFriendForCurrentUser:username :self :@selector(addParseFriendFromUsernameCallback::)];
}


- (IBAction)addFriendFromContacts:(id)sender {
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.currentResponder = textField;
}

- (void)resignOnTap:(id)sender {
    [self.currentResponder resignFirstResponder];
}

@end
