//
//  NewEventController.m
//  u.in
//
//  Created by Calvin on 7/17/14.
//  Copyright (c) 2014 Calvin Chan. All rights reserved.
//

#import "NewEventController.h"
#import "FriendsViewController.h"

@interface NewEventController()
@property (strong, nonatomic) IBOutlet UITextField *eventTitle;
@property (strong, nonatomic) IBOutlet UITextField *location;
@property (strong, nonatomic) IBOutlet UITextView *message;
@property (strong, nonatomic) IBOutlet UIDatePicker *time;

@property (nonatomic, assign) id currentResponder;
@end

@implementation NewEventController

- (void)viewDidLoad {
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:singleTap];
    
    [self setDatePickerOptions];
    
}

- (void)viewDidAppear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setDatePickerOptions {
    self.time.minimumDate = [NSDate date];
    self.time.maximumDate = [NSDate dateWithTimeIntervalSinceNow:86400];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"eventToSelectFriends"]) {
        if ([segue.destinationViewController isKindOfClass:[FriendsViewController class]]) {
            FriendsViewController *friendsVC = (FriendsViewController *)segue.destinationViewController;
            friendsVC.eventTitle = self.eventTitle.text;
            friendsVC.location = self.location.text;
            friendsVC.message = self.message.text;
            friendsVC.datetime = self.time.date;
        }
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"eventToSelectFriends"]) {
        // perform your computation to determine whether segue should occur
        
        if ([self.eventTitle.text length] <= 0) {
            UIAlertView *notPermitted = [[UIAlertView alloc]
                                         initWithTitle:@"Oops!"
                                         message:@"Please enter a title"
                                         delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
            
            [notPermitted show];
            return NO;
        } else if ([self.location.text length] <= 0) {
            UIAlertView *notPermitted = [[UIAlertView alloc]
                                         initWithTitle:@"Oops!"
                                         message:@"Please enter a location"
                                         delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
            
            [notPermitted show];
            return NO;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.currentResponder = textField;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.currentResponder = textView;
}

- (void)resignOnTap:(id)iSender {
    [self.currentResponder resignFirstResponder];
}


@end
