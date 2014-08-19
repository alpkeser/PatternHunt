//
//  PHTile.h
//  PatternHunt
//
//  Created by alp keser on 6/25/13.
//  Copyright (c) 2013 alp keser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
@class PHTileFactory;
typedef enum{
    NORMAL = 0,
    JOKER, //changing colors
    REVERSER,
    TIMEGAINER,
}TileType;
@interface PHTile : SKSpriteNode<NSCoding>{
}


@property (nonatomic,retain) PHTileFactory *myFactory;
@property (nonatomic,assign) BOOL isSelected;
@property (nonatomic,assign) int orginalColorCode;
@property (nonatomic,assign) TileType tileType;
//@property (nonatomic,assign) TileType tileType;

- (id)initWithImageNamed:(NSString *)name andTileType:(TileType)aTileType;
- (void)changeColor;
@end
