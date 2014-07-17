//
//  ContactsViewController.m
//  u.in
//
//  Created by Calvin on 7/16/14.
//  Copyright (c) 2014 Calvin Chan. All rights reserved.
//

#import "ContactsViewController.h"
#import "../Static/Contacts.h"

@interface ContactsViewController ()

@end

@implementation ContactsViewController

// ABSTRACT OVERRIDE

- (NSDictionary *)loadTableData {
    return [Contacts returnContactsForCurrentUser];
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