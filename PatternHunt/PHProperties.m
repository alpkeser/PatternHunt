//
//  PHProperties.m
//  PatternHunt
//
//  Created by alp keser on 6/25/13.
//  Copyright (c) 2013 alp keser. All rights reserved.
//

#import "PHProperties.h"

@implementation PHProperties
const float tilePerc =80;
const int corridorNumber = 10;


+ (float)getTileFactoryXByOrder:(int)anOrder inFrame:(CGRect)aFrame{
    //1/koridor 0 dan baslra
    anOrder -=1;
    //genisligi koridor sayisina bolup sirasiyla carpiyoruz ve %10 ekliyoruz bosluk
    return (((aFrame.size.width/ corridorNumber)  *anOrder) + ((aFrame.size.width/ corridorNumber) / 10) + [self getTileSizeInFrame:aFrame] /2);
    
}

+ (float)getTileSizeInFrame:(CGRect)aFrame{
    return aFrame.size.width /corridorNumber * 0.8;
    
}
+ (float)getTileFactoryYInFrame:(CGRect)aFrame{
    return aFrame.size.height * 0.90;
}
+ (float)getDistanceInFrame:(CGRect)aFrame{
    return -aFrame.size.height;
}
+ (UIColor*)getColorWithNumber:(int)aColorNumber{
    switch (aColorNumber) {
        case 0:
            return [UIColor redColor];
            break;
        case 1:
            return [UIColor blueColor];
            break;
        case 2:
            return [UIColor greenColor];
            break;
            
        default:
            break;
    }
    return [UIColor whiteColor];
}
@end
