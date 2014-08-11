//
//  PHPattern.h
//  PatternHunt
//
//  Created by Alp Keser on 12/1/13.
//  Copyright (c) 2013 alp keser. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PHPattern : NSObject
@property(nonatomic,assign) int dimension;
@property(nonatomic,assign) int numOfTiles;
@property(nonatomic,assign) int colorCode; // -1 means all colors
@property(nonatomic,retain) NSMutableArray *patternArray;
@end
