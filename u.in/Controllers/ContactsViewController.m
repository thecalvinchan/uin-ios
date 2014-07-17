//
//  ContactsViewController.m
//  u.in
//
//  Created by Calvin on 7/16/14.
//  Copyright (c) 2014 Calvin Chan. All rights reserved.
//

#import "ContactsViewController.h"
#import "../Static/Contacts.h"
#import "../Models/Users.h"

@interface ContactsViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
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

- (IBAction)addContactsToFriends:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *hashlist = [[defaults objectForKey:@"hash"] mutableCopy];
    if ([hashlist count] <=0) {
        hashlist = [[NSMutableArray alloc] init];
    }
    for (NSInteger j = 0; j < [self.tableView numberOfSections]; ++j)
    {
        for (NSInteger i = 0; i < [self.tableView numberOfRowsInSection:j]; ++i)
        {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]];
            if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
                NSString *hash = [NSString stringWithFormat: @"%@ %@", cell.textLabel.text, cell.detailTextLabel.text];
                Users *person = [self.tableData objectForKey:hash];
                [defaults setObject:[person returnDictRepresentation] forKey:hash];
                if (![hashlist containsObject:hash]) {
                    [hashlist addObject:hash];
                }
            }
        }
    }
    [defaults setObject:(NSArray *)hashlist forKey:@"hash"];
    [defaults synchronize];
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
