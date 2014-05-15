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
    NORMAL,
    JOKER,
    REVERSER
}TileType;
@interface PHTile : SKSpriteNode{
    TileType tileType;
}


@property (nonatomic,retain) PHTileFactory *myFactory;
@property (nonatomic,assign) BOOL isSelected;
@property (nonatomic,assign) int orginalColorCode;
@property (nonatomic,assign) TileType tileType;
//@property (nonatomic,assign) TileType tileType;

- (id)initWithImageNamed:(NSString *)name andTileType:(TileType)aTileType;
@end
