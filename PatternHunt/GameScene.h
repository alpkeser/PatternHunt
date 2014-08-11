//
//  GameScene.h
//  PatternHunt
//
//  Created by alp keser on 6/25/13.
//  Copyright (c) 2013 alp keser. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ScoreBoardNode.h"
#import "GCHelper.h"
typedef  enum{
    SINGLE = 0,
    MULTIPLAYER
}GameType;
@interface GameScene : SKScene<GCHelperDelegate>{
    
    NSMutableArray *selectedTiles;
    NSMutableArray *touchesStack;
    BOOL isSceneStopped;
    BOOL doesGameStarted;
    ScoreBoardNode *scoreboardNode;
    NSDate *beginTime;
    int randomTouchId;
    float secondsLeft;
    NSTimer *timer;

}
@property BOOL contentCreated;
@property (strong,nonatomic)NSMutableArray *factories;
@property (strong,nonatomic)SKShapeNode *fingerTrace;
@property (strong,nonatomic)NSMutableArray *traces;
@property (assign,nonatomic)GameType gameType;
@property (assign,nonatomic)BOOL isFinished;
@property (assign,nonatomic)BOOL isPaused;
- (NSMutableArray*)setupFactoriesWithFrame:(CGRect)aFrame;
- (void)setFactoriesFromColorCodes:(int[10][300])colorCodes andWithFrame:(CGRect)aFrame;
- (void)endGame;
@end
