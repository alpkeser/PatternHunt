//
//  PHProperties.h
//  PatternHunt
//
//  Created by alp keser on 6/25/13.
//  Copyright (c) 2013 alp keser. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PHProperties : NSObject
+ (float)getTileFactoryXByOrder:(int)anOrder inFrame:(CGRect)aFrame;
+ (float)getTileSizeInFrame:(CGRect)aFrame;
+ (float)getTileFactoryYInFrame:(CGRect)aFrame;
+ (float)getDistanceInFrame:(CGRect)aFrame;
+ (UIColor*)getColorWithNumber:(int)aColorNumber;
+ (NSString*)getImageNameWithNumber:(int)aColorNumber;
+ (float)fontSizeForScoreBoard;
+ (float)fontSizeForGameScene;
+ (float)sizeForTraceStroke;
+ (float)pauseButtonSize;
@end
