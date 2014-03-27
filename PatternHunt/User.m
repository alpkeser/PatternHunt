//
//  User.m
//  PatternHunt
//
//  Created by Alp Keser on 2/18/14.
//  Copyright (c) 2014 alp keser. All rights reserved.
//

#import "User.h"

@implementation User
static BOOL isAuthenticated;
+ (BOOL)isAuthenticated{
    return isAuthenticated;
}

+ (void)setIsAuthenticated:(BOOL)var{
    isAuthenticated = var;
}
@end
