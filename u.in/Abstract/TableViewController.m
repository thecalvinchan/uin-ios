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
@property (strong, nonatomic) NSDictionary *tableData;
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
    Users *friend = [self.tableData valueForKey:[self.tableData allKeys][indexPath.row]];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", friend.firstName, friend.lastName ];
    if ([friend.phoneNumbers count] > 0) {
        cell.detailTextLabel.text = friend.phoneNumbers[0];
    } else {
        cell.detailTextLabel.text = @"";
    }
    
    return cell;
}

@end