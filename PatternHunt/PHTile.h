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
@interface PHTile : SKSpriteNode


@property (nonatomic,retain) PHTileFactory *myFactory;
@property (nonatomic,assign) BOOL isSelected;
@property (nonatomic,assign) SKColor *orginalColor;
- (void)divideToFourPiece;
@end
