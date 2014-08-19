//
//  PHTileFactory.m
//  PatternHunt
//
//  Created by alp keser on 6/25/13.
//  Copyright (c) 2013 alp keser. All rights reserved.
//

#import "PHTileFactory.h"

@implementation PHTileFactory
@synthesize aX,aY,distance,factoryLevel,tileSize,myTiles,isRunning,order,tilePattern,tileTypes;
- (id)initWithOrder:(int)anOrder inFrame:(CGRect)aFrame isRunning:(BOOL)running{
    self = [super init];
    aX = [PHProperties getTileFactoryXByOrder:anOrder inFrame:aFrame];
    aY = [PHProperties getTileFactoryYInFrame:aFrame];
    distance = [PHProperties getDistanceInFrame:aFrame];
    factoryLevel = 4
    ;//burda renk sayisi su an icin belli oluyor
    tileSize = [PHProperties getTileSizeInFrame:aFrame];
    myTiles = [[NSMutableArray alloc] init];
    [self logVariables];
    [self setIsRunning:running];
    [self setOrder:anOrder];
    [self initTilePattern];
    return self;
    
}

- (id)initWithOrder:(int)anOrder inFrame:(CGRect)aFrame isRunning:(BOOL)running andColorCodes:(int[300])colorCodes{
    self = [super init];
    aX = [PHProperties getTileFactoryXByOrder:anOrder inFrame:aFrame];
    aY = [PHProperties getTileFactoryYInFrame:aFrame];
    distance = [PHProperties getDistanceInFrame:aFrame];
    factoryLevel = 3;//burda renk sayisi su an icin belli oluyor
    tileSize = [PHProperties getTileSizeInFrame:aFrame];
    myTiles = [[NSMutableArray alloc] init];
    [self logVariables];
    [self setIsRunning:running];
    [self setOrder:anOrder];
    [self initTilePatternWithColorCodes:colorCodes];
    return self;
    
}
-(PHTile*)generateRandomTile{
    int randomColorCode = arc4random() % factoryLevel;
    PHTile *returnTile = [[PHTile alloc] initWithImageNamed:[PHProperties getImageNameWithNumber:randomColorCode]];
    [returnTile setSize:CGSizeMake(tileSize, tileSize)];
//    [returnTile setScale:0.40];
    [returnTile setIsSelected:NO];
    [returnTile setOrginalColorCode:randomColorCode ];
//    [returnTile runAction:[SKAction rotateByAngle:45.0f duration:0]]
    [returnTile setMyFactory:self];
    [returnTile setAlpha:1.0f];
    [returnTile setTileType:[self getTileType]];
    return returnTile;
}

-(PHTile*)generateDeterminedTile{
    if ([tilePattern count] <= 0) {
//        NSLog(@"Dikkat randoma dustu");
        return [self generateRandomTile];
    }
    int randomColorCode = [(NSNumber*)[tilePattern objectAtIndex:0] intValue];
    [tilePattern removeObjectAtIndex:0];
    PHTile *returnTile = [[PHTile alloc] initWithImageNamed:[PHProperties getImageNameWithNumber:randomColorCode]];
    [returnTile setTileType:[[self.tileTypes firstObject] intValue]];
    [self.tileTypes removeObjectAtIndex:0];
    [returnTile setSize:CGSizeMake(tileSize, tileSize)];
    //    [returnTile setScale:0.40];
    [returnTile setIsSelected:NO];
    [returnTile setOrginalColorCode:randomColorCode ];
    //    [returnTile runAction:[SKAction rotateByAngle:45.0f duration:0]]
    [returnTile setMyFactory:self];
    [returnTile setAlpha:1.0f];
    
    //alp
//    SKCropNode* cropNode = [SKCropNode node];
//    SKShapeNode* mask = [SKShapeNode node];
//    [mask setPath:CGPathCreateWithRoundedRect(CGRectMake(-15, -15, 30, 30), 4, 4, nil)];
//    [mask setFillColor:[SKColor whiteColor]];
//    [cropNode setMaskNode:mask];
//    [cropNode addChild:returnTile];
    return returnTile;
}

- (void)allahinaFirlat:(SKScene*)aScene{
    

                PHTile *aTile = [self generateDeterminedTile];
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
//    NSLog(@" aX: %f aY: %f distance: %f",aX,aY,distance);
}

- (void)sendNewTile:(SKScene*)aScene{
//    if (myTiles.count == 0) {
//        [self allahinaFirlat:aScene];
//    }
//    @try {
//        
//        PHTile *lastTile = [myTiles lastObject];
//        if (!isRunning && [self doesTileReachedEnd:[myTiles objectAtIndex:0]]) {
//            return;
//        }
//        if (! (lastTile.position.y > (aY - (tileSize + (-1 * distance) * 0.005)))) {
//          
//                 [self allahinaFirlat:aScene];
//        }
//
//    }
//    @catch (NSException *exception) {
//        
//    }
//    @finally {
//        
//    }
    [self allahinaFirlat:aScene];
}

- (BOOL)shouldSendNewTile{
    if (myTiles.count == 0) {
        return YES;
    }
    @try {
        
        PHTile *lastTile = [myTiles lastObject];
        if (!isRunning && [self doesTileReachedEnd:[myTiles objectAtIndex:0]]) {
            return NO;
        }
        if (! (lastTile.position.y > (aY - (tileSize + (-1 * distance) * 0.005)))) {
            
            return YES;
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    return NO;
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

//onceden renk kodlarını tutan array init
- (void)initTilePattern{
    tilePattern  = [[NSMutableArray alloc] init];
    tileTypes  = [[NSMutableArray alloc] init];
    //300 yeterm?
    for (int sayac = 0; sayac<900; sayac++) {
        [tilePattern addObject:[NSNumber numberWithInt:(arc4random() % factoryLevel)]];
        [tileTypes addObject:[NSNumber numberWithInt:[self getTileType]]];
    }
}
- (void)initTilePatternWithColorCodes:(int[300])colorCodes{
    tilePattern  = [[NSMutableArray alloc] init];
    for (int sayac = 0; sayac<900; sayac++) {
        [tilePattern addObject:[NSNumber numberWithInt:colorCodes[sayac]]];
    }
}

- (TileType)getTileType{
    u_int32_t value = arc4random() % 10;
    u_int32_t value2  = arc4random() % 10;
    if (value2 <= 8) {
        return NORMAL;
    }
    if (value <= 5) {
        return TIMEGAINER;
    }
    if (value <=9) {
        return JOKER;
    }
    
    return REVERSER;
}


@end
