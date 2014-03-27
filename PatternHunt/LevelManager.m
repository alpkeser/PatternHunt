//
//  LevelManager.m
//  PatternHunt
//
//  Created by Alp Keser on 7/22/13.
//  Copyright (c) 2013 alp keser. All rights reserved.
//

#import "LevelManager.h"
#import "PHPattern.h"
@implementation LevelManager

float pressure;
int level;
float speed;
//pattern variables
int numberOfTiles;
int dimensions;
BOOL gameOver = NO;
PHPattern *aPattern;
+ (void)initLevels{
    //aslinda bu level 0
    level=1;
    pressure = 0;
    speed = 3;
    dimensions = 3;
    numberOfTiles = 3;
}


+ (BOOL)checkLevel:(GameScene*)aScene{
    if (gameOver) {
        return NO;
    }
    switch (level) {
        case 1:
            if (pressure>100.f) {
                //iki oldu level
               
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

+ (void)setLevel:(int)aLevel{
    switch (aLevel) {
        case 1:
            speed = 2.8;
            level = 2;
            
            break;
        case 2:
            dimensions = 4;
            numberOfTiles = 5;
            
        default:
            break;
    }
}
+ (PHPattern*)generatePattern{
    NSMutableArray *patternPositions = [[NSMutableArray alloc] init];
    PHPattern *aPattern = [[PHPattern alloc] init];
    [aPattern setNumOfTiles:numberOfTiles];
    [aPattern setDimension:dimensions];
    [aPattern setColorCode: arc4random() % 4];
    //bos array olustur
    NSMutableArray *yArray = [[NSMutableArray alloc] init];
    NSMutableArray *xArray ;
    for (int sayac = 0; sayac < dimensions; sayac++) {
        xArray = [[NSMutableArray alloc] init];
        for (int sayac2 = 0; sayac2 < dimensions; sayac2++) {
            [xArray addObject:@""];
        }
        [yArray addObject:xArray];
    }
    [aPattern setPatternArray:yArray];
    // ilk random patterni sec
    int x = arc4random() % dimensions;
    int y =arc4random() % dimensions;
    //ilk tile koyalim
    xArray = [yArray objectAtIndex:y];
    NSString *temp = (NSString*)[xArray objectAtIndex:x];
    temp =@"X";
    NSMutableArray *availTiles;
    for (int sayac = 1; sayac < numberOfTiles; sayac++) {
        
    }
}

+ (NSMutableArray*)getAvalableTilesFromPatternArray{
    
}
@end
