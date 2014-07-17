//
//  Users.h
//  u.in
//
//  Created by Calvin on 7/16/14.
//  Copyright (c) 2014 Calvin Chan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Users : NSObject
- (instancetype)initWithDict: (NSDictionary *)dict;

@property (strong,nonatomic) NSString *firstName;
@property (strong,nonatomic) NSString *lastName;
@property (strong,nonatomic) NSString *username;
@property (strong,nonatomic) NSString *email;
@property (strong,nonatomic) NSArray *phoneNumbers;
- (NSString *)returnUserHash;
- (NSDictionary *)returnDictRepresentation;
@end
