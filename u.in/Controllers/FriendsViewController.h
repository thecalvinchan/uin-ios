//
//  FriendsViewController.h
//  u.in
//
//  Created by Calvin on 7/16/14.
//  Copyright (c) 2014 Calvin Chan. All rights reserved.
//

#import "TableViewController.h"

@interface FriendsViewController : TableViewController
@property (strong,nonatomic) NSString *eventTitle;
@property (strong,nonatomic) NSString *location;
@property (strong,nonatomic) NSString *message;
@property (strong,nonatomic) NSDate *datetime;
@end
