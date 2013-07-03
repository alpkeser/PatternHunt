//
//  PHCorridor.h
//  PatternHunt
//
//  Created by alp keser on 6/25/13.
//  Copyright (c) 2013 alp keser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PHTile.h"
#import "PHTileFactory.h"
@interface PHCorridor : NSObject



@property (nonatomic,retain)PHTileFactory *myTileFactory;
@property (nonatomic,assign) int order;
@property (nonatomic,assign) float speed;

- (id)initWithOrder:(int)anOrder withFrame:(CGRect)aFrame andScene:(SKScene*)aScene andRunning:(BOOL)isRunning;
@end
