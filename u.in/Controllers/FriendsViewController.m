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
    NSArray *parseFriends = [self.tableData objectForKey:@"parseFriends"];
    NSDictionary *contactsFriends = [self.tableData objectForKey:@"contactsFriends"];
    for (NSInteger j = 0; j < [self.tableView numberOfSections]; ++j)
    {
        for (NSInteger i = 0; i < [self.tableView numberOfRowsInSection:j]; ++i)
        {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]];
            if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
                if (j==0) {
                    [guestUsers addObject:[parseFriends objectAtIndex:i]];
                } else if (j==1) {
                    NSString *hash = [NSString stringWithFormat: @"%@ %@", cell.textLabel.text, cell.detailTextLabel.text];
                    Users *person = [contactsFriends objectForKey:hash];
                    if (person.username) {
                        [guestUsers addObject:person];
                    } else {
                        [guestNumbers addObject:person];
                    }
                }
            }
        }
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             (unsigned long)NULL), ^(void) {
        NSString *utc_date_time = [NSString stringWithFormat:@"%f",[self.datetime timeIntervalSince1970] ];
        
        PFObject *event = [PFObject objectWithClassName:@"Event"];
        [event setObject:self.eventTitle forKey:@"title"];
        [event setObject:self.location forKey:@"location"];
        [event setObject:self.message forKey:@"message"];
        [event setObject:utc_date_time forKey:@"time"];

        [event setObject:[PFUser currentUser] forKey:@"createdBy"];
        PFRelation *relation = [event relationForKey:@"guestUsers"];
        for (NSString *user in guestUsers) {
            PFQuery *query = [PFUser query];
            [query whereKey:@"username" equalTo:user];
            PFObject *pfUser = [query getFirstObject];
            if (pfUser) {
                [relation addObject:pfUser];
            }
        }
        NSMutableDictionary *numbers = [[NSMutableDictionary alloc] init];
        for (Users *user in guestNumbers) {
            PFQuery *query = [PFUser query];
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
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [self performSegueWithIdentifier:@"inviteSentToFriends" sender:self];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                                message:@"Event Created"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            });
        }];
    });
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"Parse Friends";
    }
    if (section == 1)
    {
        return @"Other Friends";
    }
    return @"";
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return ((section == 0) ? [[self.tableData objectForKey:@"parseFriends"] count] : [[[self.tableData objectForKey:@"contactsFriends"] allKeys] count]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = [[self.tableData objectForKey:@"parseFriends"] objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = @"";
    } else if (indexPath.section == 1) {
        NSDictionary *contactsFriends = [self.tableData objectForKey:@"contactsFriends" ];
        NSArray *keys = [contactsFriends allKeys];
        Users *friend = [contactsFriends valueForKey:keys[indexPath.row]];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", friend.firstName, friend.lastName ];
        if ([friend.phoneNumbers count] > 0) {
            cell.detailTextLabel.text = friend.phoneNumbers[0];
        } else {
            cell.detailTextLabel.text = @"";
        }
    }
    return cell;
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
