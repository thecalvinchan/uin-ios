//
//  FriendsViewController.m
//  u.in
//
//  Created by Calvin on 7/16/14.
//  Copyright (c) 2014 Calvin Chan. All rights reserved.
//

#import "FriendsViewController.h"
#import <Parse/Parse.h>
#import "../Static/API.h"
#import "../Models/Users.h"

@interface FriendsViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation FriendsViewController

// ABSTRACT OVERRIDE

- (NSDictionary *)loadTableData {
    return [API returnFriendsForCurrentUser];
}

// END ABSTRACT OVERRIDE

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendInviteToFriends:(id)sender {
    NSMutableArray *guestUsers = [[NSMutableArray alloc] init];
    NSMutableArray *guestNumbers = [[NSMutableArray alloc] init];
    for (NSInteger j = 0; j < [self.tableView numberOfSections]; ++j)
    {
        for (NSInteger i = 0; i < [self.tableView numberOfRowsInSection:j]; ++i)
        {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]];
            if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
                NSString *hash = [NSString stringWithFormat: @"%@ %@", cell.textLabel.text, cell.detailTextLabel.text];
                Users *person = [self.tableData objectForKey:hash];
                if (person.username) {
                    [guestUsers addObject:person];
                } else {
                    [guestNumbers addObject:person];
                }
            }
        }
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             (unsigned long)NULL), ^(void) {
        PFObject *event = [PFObject objectWithClassName:@"Event"];
        [event setObject:self.inviteMessage forKey:@"message"];
        [event setObject:[PFUser currentUser] forKey:@"createdBy"];
        PFRelation *relation = [event relationForKey:@"guestUsers"];
        for (Users *user in guestUsers) {
            PFQuery *query = [PFQuery queryWithClassName:@"User"];
            [query whereKey:@"username" equalTo:user.username];
            PFObject *pfUser = [query getFirstObject];
            if (pfUser) {
                [relation addObject:pfUser];
            }
        }
        NSMutableDictionary *numbers = [[NSMutableDictionary alloc] init];
        for (Users *user in guestNumbers) {
            PFQuery *query = [PFQuery queryWithClassName:@"User"];
            [query whereKey:@"phoneNumber" containedIn:user.phoneNumbers];
            PFObject *pfUser = [query getFirstObject];
            if (pfUser) {
                [relation addObject:pfUser];
            } else {
                for (NSString *number in user.phoneNumbers) {
                    [numbers setObject:@"false" forKey:number];
                }
            }
        }
        [event setObject:numbers forKey:@"phoneNumbers"];
        [event saveInBackgroundWithBlock:^(BOOL success,NSError *err) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                            message:@"Event Created"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }];
    });
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
