//
//  LevelManager.h
//  PatternHunt
//
//  Created by Alp Keser on 7/22/13.
//  Copyright (c) 2013 alp keser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameScene.h"
@interface LevelManager : NSObject

+ (BOOL)checkLevel:(GameScene*)aScene;
+ (int)calculatePointWith:(int)noOfTiles andLevel:(int)aLevel andPressure:(float)aPressure;
+ (void)increasePressure:(float)amount;
+ (void)decreasePressure:(float)amount;
+ (void)initLevels;
+ (int)getSpeed;
+ (void)setSpeed;
+ (int)getLevel;

@end
