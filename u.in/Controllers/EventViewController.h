//
//  EventViewController.h
//  u.in
//
//  Created by Calvin on 7/20/14.
//  Copyright (c) 2014 Calvin Chan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface EventViewController : UIViewController
@property (strong, nonatomic) PFObject *event;
@end
