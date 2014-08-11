//
//  User.h
//  PatternHunt
//
//  Created by Alp Keser on 2/18/14.
//  Copyright (c) 2014 alp keser. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
+ (BOOL)isAuthenticated;
+ (void)setIsAuthenticated:(BOOL)var;

@end
