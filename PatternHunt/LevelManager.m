//
//  LevelManager.m
//  PatternHunt
//
//  Created by Alp Keser on 7/22/13.
//  Copyright (c) 2013 alp keser. All rights reserved.
//

#import "LevelManager.h"

@implementation LevelManager

float pressure;
int level;
float speed;
BOOL gameOver = NO;
+ (void)initLevels{
    level=1;
    pressure = 0;
    speed = 3;
}


+ (BOOL)checkLevel:(GameScene*)aScene{
    if (gameOver) {
        return NO;
    }
    switch (level) {
        case 1:
            if (pressure>100.f) {
                //iki oldu level
                speed = 2.8;
                level = 2;
                return YES;
            }
            break;
        case 2:
            if (pressure>200.f) {
                speed = 2.4;
                level = 3;
                return YES;
            }
            break;
        case 3:
            if ( 600.0f> pressure>300.f) {
                speed = 2;
                level = 4;
                return YES;
            }
            [aScene endGame];
            break;
            
        default:
            break;
    }
    return NO;
}

+ (int)calculatePointWith:(int)noOfTiles andLevel:(int)aLevel andPressure:(float)aPressure{
    
    return  (level * pow(2,noOfTiles));
}

+ (void)increasePressure:(float)amount{
    pressure +=amount;
}

+ (void)decreasePressure:(float)amount{
    pressure -=amount;
}

+ (float)getPressure{
    return pressure;
}

+ (int)getLevel{
    return level;
}
+ (int)getSpeed{
    return speed;
}
+ (void)setSpeed:(float)aSpeed{
    speed = aSpeed;
}
@end
