//
//  ViewController.m
//  u.in
//
//  Created by Calvin on 7/16/14.
//  Copyright (c) 2014 Calvin Chan. All rights reserved.
//

#import "TableViewController.h"
#import "../Models/Users.h"

@interface TableViewController ()
@end

@implementation TableViewController

// ABSTRACT

- (NSDictionary *)loadTableData {
    return nil;
}

// END ABSTRACT

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableData = [self loadTableData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.tableData = [self loadTableData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSArray *keys = [self.tableData allKeys];
    Users *friend = [self.tableData valueForKey:keys[indexPath.row]];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", friend.firstName, friend.lastName ];
    if ([friend.phoneNumbers count] > 0) {
        cell.detailTextLabel.text = friend.phoneNumbers[0];
    } else {
        cell.detailTextLabel.text = @"";
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

@end
