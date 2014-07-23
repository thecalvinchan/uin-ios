//
//  FriendsViewController.m
//  u.in
//
//  Created by Calvin on 7/16/14.
//  Copyright (c) 2014 Calvin Chan. All rights reserved.
//

#import "AllFriendsViewController.h"
#import <Parse/Parse.h>
#import "../Static/API.h"
#import "../Models/Users.h"

@interface AllFriendsViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation AllFriendsViewController

// ABSTRACT OVERRIDE

- (void)loadTableData {
    self.tableData = [API returnFriendsForCurrentUser];
    NSLog(@"%@",self.tableData);
    NSLog(@"loadTableData");
    [self.tableView reloadData];
}

// END ABSTRACT OVERRIDE

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self.tableView reloadData];
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
