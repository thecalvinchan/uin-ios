//
//  ViewController.h
//  u.in
//
//  Created by Calvin on 7/16/14.
//  Copyright (c) 2014 Calvin Chan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSDictionary *tableData;
@end
