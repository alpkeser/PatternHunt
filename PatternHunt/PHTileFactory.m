//
//  PHTileFactory.m
//  PatternHunt
//
//  Created by alp keser on 6/25/13.
//  Copyright (c) 2013 alp keser. All rights reserved.
//

#import "PHTileFactory.h"

@implementation PHTileFactory
@synthesize aX,aY,distance,factoryLevel,tileSize,myTiles,isRunning,order;
- (id)initWithOrder:(int)anOrder inFrame:(CGRect)aFrame isRunning:(BOOL)running{
    self = [super init];
    aX = [PHProperties getTileFactoryXByOrder:anOrder inFrame:aFrame];
    aY = [PHProperties getTileFactoryYInFrame:aFrame];
    distance = [PHProperties getDistanceInFrame:aFrame];
    factoryLevel = 3;
    tileSize = [PHProperties getTileSizeInFrame:aFrame];
    myTiles = [[NSMutableArray alloc] init];
    [self logVariables];
    [self setIsRunning:running];
    [self setOrder:anOrder];
    return self;
    
}
-(PHTile*)generateRandomTile{
    int randomColorCode = arc4random() % factoryLevel;
    PHTile *returnTile =[[PHTile alloc] initWithColor:[PHProperties getColorWithNumber:randomColorCode] size:CGSizeMake(tileSize,tileSize)];
    [returnTile setIsSelected:NO];
    [returnTile setOrginalColor:[PHProperties getColorWithNumber:randomColorCode] ];
    //for temp
    if (randomColorCode == 0) {
        returnTile = [[PHTile alloc] initWithImageNamed:@"normal_turuncu.png"];
        [returnTile setSize:CGSizeMake(tileSize, tileSize)];
    }
    [returnTile setMyFactory:self];
    [returnTile setAlpha:0.6f];
    return returnTile;
}
- (void)allahinaFirlat:(SKScene*)aScene{
    

                PHTile *aTile = [self generateRandomTile];
                [myTiles addObject:aTile];
                [aTile setPosition:CGPointMake(aX, aY)];
                [aScene addChild:aTile];
                [self moveSpriteEndOfCorridor:aTile];
            
            



}


- (BOOL)doesTileReachedEnd:(PHTile*)aTile{
    //NSLog(@"tile position : %f",aTile.position.y);
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
                                           [SKAction moveByX:0 y:distance duration: [LevelManager getSpeed]],
                                           [SKAction removeFromParent]]];
    [aSpriteNode runAction:gitGeber completion:^(void){
        [myTiles removeObject:aSpriteNode];
    }];
}

-(void)logVariables{
    NSLog(@" aX: %f aY: %f distance: %f",aX,aY,distance);
}

- (void)sendNewTile:(SKScene*)aScene{
    if (myTiles.count == 0) {
        [self allahinaFirlat:aScene];
    }
    @try {
        
        PHTile *lastTile = [myTiles lastObject];
        if (!isRunning && [self doesTileReachedEnd:[myTiles objectAtIndex:0]]) {
            return;
        }
        if (! (lastTile.position.y > (aY - (tileSize + (-1 * distance) * 0.005)))) {
          
                 [self allahinaFirlat:aScene];
        }

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}


- (void)stopTheTiles{
    for (PHTile*tempTile in myTiles) {
        [tempTile removeAllActions];
    }
}

- (void)runTheTiles{
    for (PHTile*tempTile in myTiles) {
        [self moveSpriteEndOfCorridor:tempTile];
    }
    isRunning = YES;
}
@end
