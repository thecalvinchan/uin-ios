//
//  ViewController.m
//  u.in
//
//  Created by Calvin on 7/16/14.
//  Copyright (c) 2014 Calvin Chan. All rights reserved.
//

#import "ViewController.h"
#import "Models/Users.h"

@interface ViewController ()
@property (strong, nonatomic) NSMutableArray *tableData;
@end

@implementation ViewController

// ABSTRACT

- (NSMutableArray *)loadTableData {
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
    return cell;
}

@end
