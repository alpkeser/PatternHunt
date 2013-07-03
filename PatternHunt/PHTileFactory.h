//
//  PHTileFactory.h
//  PatternHunt
//
//  Created by alp keser on 6/25/13.
//  Copyright (c) 2013 alp keser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PHTile.h"
@interface PHTileFactory : NSObject
@property (nonatomic,assign) float aX;
@property (nonatomic,assign) float aY;
@property (nonatomic,assign) float distance;
@property (nonatomic,assign) float tileSize;
@property (nonatomic,assign) float speed;
@property (nonatomic,assign) int factoryLevel;
@property (nonatomic,retain) NSMutableArray *myTiles;
- (id)initWithOrder:(int)anOrder inFrame:(CGRect)aFrame;
- (PHTile*)generateRandomTile;
- (void)allahinaFirlat:(SKScene*)aScene;
- (void)birSeriFirlat:(SKScene*)aScene;
- (void)stopTheTiles;
@end
