//
//  DataManager.h
//  PatternHunt
//
//  Created by Alp Keser on 8/20/14.
//  Copyright (c) 2014 alp keser. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject

- (void)setupDB;
- (void)loadDummyData;
- (void)deleteDB;
@end
