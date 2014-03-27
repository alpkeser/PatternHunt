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
    return aFrame.size.width /corridorNumber * 0.9;
    
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
        case 3:
            return [UIColor purpleColor];
            
        default:
            break;
    }
    return [UIColor whiteColor];
}

+ (NSString*)getImageNameWithNumber:(int)aColorNumber{
    switch (aColorNumber) {
        case 0:
            //kırmızı
            return @"redTile.png";
            break;
        case 1:
            //maviiii
            return @"blueTile.png";
            break;
        case 2:
            
            //yesillll
            return @"greenTile.png";
            break;
        case 3:
//            morrrr
            return @"purpleTile.png";
        case 4:
            //siyah
            return @"blackTile.png";
        default:
            break;
    }
    
    //sicti cafer bez getir
    //siyahh
     return @"blackTile.png";
}
@end
