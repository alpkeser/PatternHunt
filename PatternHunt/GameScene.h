//
//  GameScene.h
//  PatternHunt
//
//  Created by alp keser on 6/25/13.
//  Copyright (c) 2013 alp keser. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ScoreboardView.h"
#import "ScoreBoardScene.h"
@interface GameScene : SKScene{
    NSMutableArray *factories;
    NSMutableArray *selectedTiles;
    NSMutableArray *touchesStack;
    BOOL isSceneStopped;
    BOOL doesGameStarted;
    ScoreBoardScene *scoreboardScene;
    NSDate *beginTime;
    int randomTouchId;

}
@property BOOL contentCreated;
-(void)endGame;
@end
