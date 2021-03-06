//
//  PHTileFactory.h
//  PatternHunt
//
//  Created by alp keser on 6/25/13.
//  Copyright (c) 2013 alp keser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PHTile.h"
#import "LevelManager.h"
@interface PHTileFactory : NSObject
@property (nonatomic,assign) float aX;
@property (nonatomic,assign) float aY;
@property (nonatomic,assign) float distance;
@property (nonatomic,assign) float tileSize;
@property (nonatomic,assign) int factoryLevel;
@property (nonatomic,assign) int order;
@property (nonatomic,assign) BOOL isRunning;
@property (nonatomic,retain) NSMutableArray *myTiles;
@property (nonatomic,retain) NSMutableArray *tilePattern; //multi icin geldi..onceden belirlenmis pattern
@property (nonatomic,retain) NSMutableArray *tileTypes; //multi icin geldi..pattern types

- (id)initWithOrder:(int)anOrder inFrame:(CGRect)aFrame isRunning:(BOOL)running;
- (id)initWithOrder:(int)anOrder inFrame:(CGRect)aFrame isRunning:(BOOL)running andColorCodes:(int[900])colorCodes;
- (PHTile*)generateRandomTile;
- (void)sendNewTile:(SKScene*)aScene;
- (BOOL)shouldSendNewTile;

- (void)runTheTiles;
- (void)stopTheTiles;

//testing aalpk
 
//testing aalpk
@end
