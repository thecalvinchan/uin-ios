//
//  EventViewController.m
//  u.in
//
//  Created by Calvin on 7/20/14.
//  Copyright (c) 2014 Calvin Chan. All rights reserved.
//

#import "EventViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>

@interface EventViewController ()
@property (strong, nonatomic) IBOutlet UILabel *eventTitle;
@property (strong, nonatomic) IBOutlet UILabel *eventLocation;
@property (strong, nonatomic) IBOutlet UILabel *hostUser;
@property (strong, nonatomic) IBOutlet UITableView *guestTable;
@property (strong, nonatomic) NSArray *attendingUsers;
@property (strong, nonatomic) NSArray *invitedUsers;
@property (strong, nonatomic) NSArray *attendingNumbers;
@property (strong, nonatomic) NSArray *invitedNumbers;
@property (strong, nonatomic) IBOutlet UIButton *attendingButton;
@end

@implementation EventViewController

- (void)setAttending:(UIColor *)color
{
    UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];    colorView.backgroundColor = color;
    UIGraphicsBeginImageContext(colorView.bounds.size);
    [colorView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *colorImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.attendingButton setBackgroundImage:colorImage forState:UIControlStateSelected];
    [self.attendingButton setTitle:@"You're Attending!" forState:UIControlStateSelected];
    [self.attendingButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.eventTitle.text = [self.event objectForKey:@"title"];
    self.eventLocation.text = [self.event objectForKey:@"location"];
    self.hostUser.text = [[self.event objectForKey:@"createdBy"] objectForKey:@"username"];
    [self setAttending:[UIColor greenColor]];
    if ([self checkAttending]) {
        [self.attendingButton setSelected:YES];
    }
    [self loadAttendingUsers];
    // Do any additional setup after loading the view.
}

- (BOOL) checkAttending {
    if ([[[PFUser currentUser] objectId] isEqualToString:[[self.event objectForKey:@"createdBy"] objectId]]) {
        return true;
    }
    for (PFObject *attendee in self.attendingUsers) {
        if ([[[PFUser currentUser] objectId] isEqualToString:[attendee objectId]]) {
            return true;
        }
    }
    return false;
}

- (void) loadAttendingUsers{
    PFRelation *relation = [self.event relationforKey:@"attendingUsers"];
    PFQuery *query = [relation query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *err) {
        NSLog(@"%@ %@",[[PFUser currentUser] objectId],[[self.event objectForKey:@"createdBy"] objectId]);
        if (err) {
            self.attendingUsers = [[NSArray alloc] init];
            return;
        }
        NSMutableArray *attendees = [objects mutableCopy];
        if ([[[PFUser currentUser] objectId] isEqualToString:[[self.event objectForKey:@"createdBy"] objectId]]) {
            NSLog(@"%@ %@",[[PFUser currentUser] objectId],[[self.event objectForKey:@"createdBy"] objectId]);
            NSLog(@"%@",attendees);
            [attendees insertObject:[PFUser currentUser] atIndex:0];
        }
        self.attendingUsers = attendees;
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            if ([self checkAttending]) {
                [self.attendingButton setSelected:YES];
            }
            [self.guestTable reloadData];
        });
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    [self.event objectForKey:@"attendingUsers"];
    
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"Users";
    }
    if (section == 1)
    {
        return @"Others";
    }
    return @"";
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return [self.attendingUsers count];
    }
    if (section == 1)
    {
        return [self.attendingNumbers count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.section == 0) {
        PFObject *user = [self.attendingUsers objectAtIndex:indexPath.row];
        cell.textLabel.text = [user objectForKey:@"username"];
    } else if (indexPath.section == 1) {
        cell.textLabel.text = [self.attendingNumbers objectAtIndex:indexPath.row];
    }
    cell.detailTextLabel.text = @"";
    return cell;
}

- (IBAction)attendEvent:(id)sender {
    if ([[[PFUser currentUser] objectId] isEqualToString:[[self.event objectForKey:@"createdBy"] objectId]]) {
        return;
    }
    PFRelation *relation = [self.event relationforKey:@"attendingUsers"];
    if ([sender isSelected]) {
        [relation removeObject:[PFUser currentUser]];
    } else {
        [relation addObject:[PFUser currentUser]];
    }
    [self.event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *err) {
        if (succeeded) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [self loadAttendingUsers];
                if ([sender isSelected]) {
                    [sender setSelected:NO];
                } else {
                    [sender setSelected:YES];
                }
            });
            PFQuery *attendingUsers = [relation query];
            [attendingUsers whereKey:@"objectId" notEqualTo:[[PFUser currentUser] objectId]];
            PFQuery *pushQuery = [PFInstallation query];
            [pushQuery whereKey:@"deviceType" equalTo:@"ios"];
            [pushQuery whereKey:@"User" matchesQuery:attendingUsers];
            [PFPush sendPushMessageToQueryInBackground:pushQuery
                                           withMessage:@"Hello World!"];
        }
    }];
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
