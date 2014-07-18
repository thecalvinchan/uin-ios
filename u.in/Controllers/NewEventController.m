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

@property (strong, nonatomic) IBOutlet UITextView *inviteMessage;
@end

@implementation NewEventController

- (void)viewDidLoad {
}

- (void)viewDidAppear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"eventToSelectFriends"]) {
        if ([segue.destinationViewController isKindOfClass:[FriendsViewController class]]) {
            FriendsViewController *friendsVC = (FriendsViewController *)segue.destinationViewController;
            friendsVC.inviteMessage = self.inviteMessage.text;
        }
    }
}
@end
