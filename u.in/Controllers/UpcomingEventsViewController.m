//
//  UpcomingEventsViewController.m
//  u.in
//
//  Created by Calvin on 7/19/14.
//  Copyright (c) 2014 Calvin Chan. All rights reserved.
//

#import "UpcomingEventsViewController.h"
#import "EventViewController.h"
#import <Parse/Parse.h>
#import "../Static/API.h"

@interface UpcomingEventsViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableDictionary *tableData;
@property (strong, nonatomic) NSArray *eventsByUser;
@end

@implementation UpcomingEventsViewController

- (NSMutableDictionary *)tableData {
    if (!_tableData) {
        _tableData = [[NSMutableDictionary alloc] init];
    }
    return _tableData;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([PFUser currentUser]) {
        [API queryUpcomingEventsByCurrentUser:self :@selector(parseQueryDataForEventsByUser::)];
        [API queryUpcomingInvitationsForCurrentUser:self :@selector(parseQueryDataForInvitationsForUser::)];
    }
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([PFUser currentUser]) {
        [API queryUpcomingEventsByCurrentUser:self :@selector(parseQueryDataForEventsByUser::)];
        [API queryUpcomingInvitationsForCurrentUser:self :@selector(parseQueryDataForInvitationsForUser::)];
    }
}

- (void)parseQueryDataForEventsByUser:(NSArray *)events :(NSError *)err {
    if (err) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Failure"
                                                        message:@"Data could not be loaded. Check your internet connection"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [self.tableData setValue:(NSArray *)events forKey:@"eventsByUser"];
        [self.tableView reloadData];
    });
    return;
    NSMutableArray *upcomingEvents = [[NSMutableArray alloc] init];
    for (PFObject *event in events) {
        NSMutableDictionary *e = [[NSMutableDictionary alloc] init];
        NSString *title = [event objectForKey:@"title"];
        if (!title) {
            title = @"";
        }
        PFObject *user = [event objectForKey:@"createdBy"];
        [user fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            NSString *createdBy = [user objectForKey:@"username"];
            if (!createdBy) {
                createdBy = @"";
            }
            [e setObject:title forKey:@"title"];
            [e setObject:createdBy forKey:@"createdBy"];
            [upcomingEvents addObject:(NSDictionary *)e];
            NSLog(@"%@",upcomingEvents);
            dispatch_async(dispatch_get_main_queue(), ^ {
                [self.tableData setValue:(NSArray *)upcomingEvents forKey:@"eventsByUser"];
                [self.tableView reloadData];
            });
        }];
    }
}

// Should probably just return a lambda with the correct things binded in
- (void)parseQueryDataForInvitationsForUser:(NSArray *)events :(NSError *)err {
    if (err) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Failure"
                                                        message:@"Data could not be loaded. Check your internet connection"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [self.tableData setValue:(NSArray *)events forKey:@"invitationsForUser"];
        [self.tableView reloadData];
    });
    return;
    NSMutableArray *upcomingEvents = [[NSMutableArray alloc] init];
    for (PFObject *event in events) {
        NSMutableDictionary *e = [[NSMutableDictionary alloc] init];
        NSString *title = [event objectForKey:@"title"];
        if (!title) {
            title = @"";
        }
        PFObject *user = [event objectForKey:@"createdBy"];
        [user fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            NSString *createdBy = [user objectForKey:@"username"];
            if (!createdBy) {
                createdBy = @"";
            }
            [e setObject:title forKey:@"title"];
            [e setObject:createdBy forKey:@"createdBy"];
            [upcomingEvents addObject:(NSDictionary *)e];
            NSLog(@"%@",upcomingEvents);
            dispatch_async(dispatch_get_main_queue(), ^ {
                [self.tableData setValue:(NSArray *)upcomingEvents forKey:@"invitationsForUser"];
                [self.tableView reloadData];
            });
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"Events Created By Me";
    }
    if (section == 1)
    {
        return @"Events I'm Invited To";
    }
    return @"";
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return ((section == 0) ? [[self.tableData objectForKey:@"eventsByUser"] count] : [[self.tableData objectForKey:@"invitationsForUser"] count]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSArray *data;
    if (indexPath.section == 0) {
        data = [self.tableData objectForKey:@"eventsByUser"];
    } else if (indexPath.section == 1) {
        data = [self.tableData objectForKey:@"invitationsForUser"];
    }
    NSDictionary *event = data[indexPath.row];
    cell.textLabel.text = [event objectForKey:@"title"];
    cell.detailTextLabel.text = [[event objectForKey:@"createdBy"] objectForKey:@"username"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (IBAction)inviteSentToFriends:(UIStoryboardSegue *)segue
{
    // do any clean up you want
    [API queryUpcomingEventsByCurrentUser:self :@selector(parseQueryDataForEventsByUser::)];
    [API queryUpcomingInvitationsForCurrentUser:self :@selector(parseQueryDataForInvitationsForUser::)];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"eventDetails"]) {
        if ([segue.destinationViewController isKindOfClass:[EventViewController class]]) {
            NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
            NSInteger section = indexPath.section;
            NSInteger index = indexPath.row;
            PFObject *event;
            if (section == 0) {
                event = [[self.tableData objectForKey:@"eventsByUser"] objectAtIndex:index];
            } else {
                event = [[self.tableData objectForKey:@"invitationsForUser"] objectAtIndex:index];
            }
            EventViewController *eventDetailsVC = (EventViewController *)segue.destinationViewController;
            NSLog(@"%@",[event objectForKey:@"title"]);
            eventDetailsVC.event = event;
        }
    }
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
