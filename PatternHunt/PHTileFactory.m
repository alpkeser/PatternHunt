//
//  PHTileFactory.m
//  PatternHunt
//
//  Created by alp keser on 6/25/13.
//  Copyright (c) 2013 alp keser. All rights reserved.
//

#import "PHTileFactory.h"

@implementation PHTileFactory
@synthesize aX,aY,distance,factoryLevel,tileSize,myTiles;
- (id)initWithOrder:(int)anOrder inFrame:(CGRect)aFrame{
    self = [super init];
    aX = [PHProperties getTileFactoryXByOrder:anOrder inFrame:aFrame];
    aY = [PHProperties getTileFactoryYInFrame:aFrame];
    distance = [PHProperties getDistanceInFrame:aFrame];
    factoryLevel = 3;
    tileSize = [PHProperties getTileSizeInFrame:aFrame];
    myTiles = [[NSMutableArray alloc] init];
    [self logVariables];
    return self;
    
}
-(PHTile*)generateRandomTile{
    int randomColorCode = arc4random() % factoryLevel;
    return [[PHTile alloc] initWithColor:[PHProperties getColorWithNumber:randomColorCode] size:CGSizeMake(tileSize,tileSize)];
}
- (void)allahinaFirlat:(SKScene*)aScene{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             (unsigned long)NULL), ^(void) {
        while (true) {
            if ([self shouldSendNewTile]) {
                PHTile *aTile = [self generateRandomTile];
                [myTiles addObject:aTile];
                [aTile setPosition:CGPointMake(aX, aY)];
                [aScene addChild:aTile];
                [self moveSpriteEndOfCorridor:aTile];
            }
            

//            NSCondition
        }
    });
    
}

- (void)birSeriFirlat:(SKScene*)aScene{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             (unsigned long)NULL), ^(void) {
        while (true) {
            
        if ([self shouldSendNewTile] && ([[aScene children] count] == 0 || ![self doesTileReachedEnd:(PHTile*)[myTiles objectAtIndex:0]])) {
                PHTile *aTile = [self generateRandomTile];
                [myTiles addObject:aTile];
                [aTile setPosition:CGPointMake(aX, aY)];
                [aScene addChild:aTile];
                [aTile runAction:[SKAction sequence:@[
                                                      [SKAction moveByX:0 y:distance   duration:1]
                                                      ]]];
            
            
            
            //            NSCondition
        }
        }
    });
    
}
- (BOOL)doesTileReachedEnd:(PHTile*)aTile{
    NSLog(@"tile position : %f",aTile.position.y);
    if(aTile.position.y-(tileSize /2) > -distance*0.01){
        return NO;
    }else{
        [self stopTheTiles];
        return YES;
    }
}
- (void)moveSpriteEndOfCorridor:(SKSpriteNode*)aSpriteNode{
    SKAction *gitGeber = [SKAction sequence:@[
                                           [SKAction waitForDuration:0.0],
                                           [SKAction moveByX:0 y:distance duration:3],
                                           [SKAction removeFromParent]]];
    [aSpriteNode runAction:gitGeber completion:^(void){
        [myTiles removeObject:aSpriteNode];
    }];
}

-(void)logVariables{
    NSLog(@" aX: %f aY: %f distance: %f",aX,aY,distance);
}

- (BOOL)shouldSendNewTile{
    if (myTiles.count == 0) {
        return YES;
    }
    @try {
        PHTile *lastTile = [myTiles lastObject];

        if (lastTile.position.y > (aY - (tileSize + (-1 * distance) * 0.05))) {
            return NO;
        }else{
            return YES;
        }

    }
    @catch (NSException *exception) {
        return YES;
    }
    @finally {
        
    }
    }

- (void)stopTheTiles{
    for (PHTile*tempTile in myTiles) {
        [tempTile removeAllActions];
    }
}
@end
