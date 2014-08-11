//
//  PHProperties.m
//  PatternHunt
//
//  Created by alp keser on 6/25/13.
//  Copyright (c) 2013 alp keser. All rights reserved.
//

#import "PHProperties.h"

@implementation PHProperties
const float tilePerc =50;
const int corridorNumber = 10;
BOOL const isMute;
NSString const * isMuteKey = @"ISMUTE";
+ (float)getTileFactoryXByOrder:(int)anOrder inFrame:(CGRect)aFrame{
    //1/koridor 0 dan baslra
    anOrder -=1;
    //genisligi koridor sayisina bolup sirasiyla carpiyoruz ve %10 ekliyoruz bosluk
    return (((aFrame.size.width/ corridorNumber)  *anOrder) + ((aFrame.size.width/ corridorNumber) / 10) + [self getTileSizeInFrame:aFrame] /2);
    
}

+ (float)getTileSizeInFrame:(CGRect)aFrame{
    return aFrame.size.width /corridorNumber * 0.7;
    
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

+ (void)setMute:(BOOL)isMute{
    NSUserDefaults *standarduserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *param;
    if (isMute) {
        param = @"T";
    }else{
        param = @"F";
    }
    [standarduserDefaults setObject:param forKey:isMuteKey];
    [standarduserDefaults synchronize];
}

+ (BOOL)isMute{
    NSUserDefaults *standarduserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *param = [standarduserDefaults objectForKey:isMuteKey];
    if ([param isEqualToString:@"F"]) {
        return NO;
    }
    
    return YES;

}

#pragma mark - Size Methods
+ (float)fontSizeForScoreBoard{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return 19.0f;
    }else{
        return 12.0f;
    }
}

+ (float)fontSizeForGameScene{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return 22.0f;
    }else{
        return 14.0f;
    }
}
+ (float)sizeForTraceStroke{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return 10.0f;
    }else{
        return 5.0f;
    }
}
+ (float)pauseButtonSize{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return 30.0f;
    }else{
        return 20.0f;
    }
}
@end
