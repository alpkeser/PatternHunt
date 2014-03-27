//
//  MenuScene.m
//  PatternHunt
//
//  Created by alp keser on 6/25/13.
//  Copyright (c) 2013 alp keser. All rights reserved.
//

#import "MenuScene.h"
#import "GameScene.h"
#import "AppDelegate.h"
#define kSingleButtonYPosition 0.70
#define kDuelButtonYPosition 0.60
#define kLeaderboardsButtonYPosition 0.50
@implementation MenuScene

@synthesize contentCreated,parentVC;

- (void)didMoveToView:(SKView *)view{
    if (!self.contentCreated) {
        [self createSceneContents];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(findMatch)
                                                 name:kGameCenterLoggedIn
                                               object:nil];

}
- (void)createSceneContents{
    SKSpriteNode *bgNode = [[SKSpriteNode alloc] initWithImageNamed:@"bg.png"];
    [bgNode setSize:self.size];
    [bgNode setPosition:CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame))];
    [self addChild:bgNode];
    [self setScaleMode:SKSceneScaleModeAspectFit];
    [self addChild:[self singleNode]];
    [self addChild:[self duelNode]];
    [self addChild:[self leaderboardNode]];
    
    
}

- (SKLabelNode*)singleNode{
    SKLabelNode *singleNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    [singleNode setText:@"Single"];
    [singleNode setFontSize:22];
    [singleNode setPosition:CGPointMake(CGRectGetMidX(self.frame),self.frame.size.height * kSingleButtonYPosition)];
    [singleNode setName:@"singleNode"];
    return singleNode;
}

//Duel playing via gamecenter
- (SKLabelNode*)duelNode{
    SKLabelNode *duelNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    [duelNode setText:@"Duel"];
    [duelNode setFontSize:22];
    [duelNode setPosition:CGPointMake(CGRectGetMidX(self.frame),self.frame.size.height * kDuelButtonYPosition)];
    [duelNode setName:@"duelNode"];
    return duelNode;

}

//Leaderboards button
- (SKLabelNode*)leaderboardNode{
    SKLabelNode *leaderboardNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    [leaderboardNode setText:@"Leaderboards"];
    [leaderboardNode setFontSize:22];
    [leaderboardNode setPosition:CGPointMake(CGRectGetMidX(self.frame),self.frame.size.height * kLeaderboardsButtonYPosition)];
    [leaderboardNode setName:@"leaderboardNode"];
    return leaderboardNode;
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    SKNode *helloNode = [self nodeAtPoint:[(UITouch*)[touches anyObject] locationInNode:self]] ;
    if(helloNode == nil)
        return;
    
    if ([[helloNode name] isEqualToString:@"singleNode"]) {
        playerMode = SINGLE_PLAYER;
        [self startGame:helloNode];
//        [self showGameModePanel];
        return;
    }
    UIAlertView *alert;
    if ([[helloNode name] isEqualToString:@"duelNode"]) {
        playerMode = MULTIPLAYER;
        if ([[GKLocalPlayer localPlayer] isAuthenticated]) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startDuel) name:kGameCenterStartDuel object:nil];
            [self findMatch];
            //adam bulunca maci baslat
            
        }else{
            alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Wait a second to connect to gamecenter.. Then try again!!" delegate:nil cancelButtonTitle:@"Allright" otherButtonTitles: nil];
            [alert show];
        }

//        [self showGameModePanel];
        return;
    }
    
    
    
#pragma mark - game mode code
//    if ([[helloNode name] isEqualToString:@"deatmatchNode"]) {
//        gameMode = DEATHMATCH;
//
//        
//    }
//    if ([[helloNode name] isEqualToString:@"longestNode"]) {
//        gameMode = LONGEST;
//
//        
//    }
//

    
}

- (void)showGameModePanel{
    SKSpriteNode *panel = [[SKSpriteNode alloc] initWithColor:[UIColor redColor] size:CGSizeMake(200, 200)];
    [panel setPosition:CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame))];
    [panel setName:@"panel"];
    [self addChild:panel];
    
    //adding deathmatch
    //
    SKLabelNode *deathmatchButtonNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    [deathmatchButtonNode setText:@"Deathmatch"];
    [deathmatchButtonNode setFontSize:22];
    [deathmatchButtonNode setPosition:CGPointMake(deathmatchButtonNode.position.x, panel.size.height * 0.10)];
    [deathmatchButtonNode setName:@"deathmatchNode"];
    [panel addChild:deathmatchButtonNode];
    
    //adding longest
    //
    SKLabelNode *longestButtonNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    [longestButtonNode setText:@"Longest"];
    [longestButtonNode setFontSize:22];
    [longestButtonNode setPosition:CGPointMake(deathmatchButtonNode.position.x, -panel.size.height * 0.10)];
    [longestButtonNode setName:@"longestmatchNode"];
    [panel addChild:longestButtonNode];
    
}

- (void)findMatch{
    //    AppDelegate * delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    [[GCHelper sharedInstance] findMatchWithMinPlayers:2 maxPlayers:2 viewController:self.parentVC delegate:self];
}


- (void)startGame:(SKNode*)aNode{
    SKAction *moveup = [SKAction moveByX:0 y:50 duration:0.5];
    SKAction *zoom = [SKAction scaleTo:2.0 duration:0.25];
    SKAction *pause = [SKAction waitForDuration:0.5];
    SKAction *fadeAway = [SKAction fadeInWithDuration:0.25];
    SKAction *remove = [SKAction removeFromParent];
    SKAction *seq = [SKAction sequence:@[moveup,zoom,pause,fadeAway,remove]];
    [aNode runAction:seq completion:^{
        SKScene *gameScene = [[GameScene alloc] initWithSize:self.size];
        SKTransition *doors = [SKTransition doorsOpenVerticalWithDuration:0.5];
        [self.view presentScene:gameScene transition:doors];
    }];
}
- (void)startDuel{

    
    [self startGame:(SKNode*)[self children ].lastObject];
    
}


#pragma mark - network methods

- (void)sendRandomNumber {
    
    MessageRandomNumber message;
    message.message.messageType = kMessageTypeRandomNumber;
    message.randomNumber = arc4random();
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageRandomNumber)];
    [self sendData:data];
}
- (void)sendData:(NSData *)data {
    NSError *error;
    BOOL success = [[GCHelper sharedInstance].match sendDataToAllPlayers:data withDataMode:GKMatchSendDataReliable error:&error];
    if (!success) {
        NSLog(@"Error sending init packet");
        [self matchEnded];
    }
}

#pragma mark GCHelperDelegate

- (void)prepareMatch{
    //ids exchanged
    [self sendRandomNumber];
}

- (void)matchStarted {
    NSLog(@"Match started");
    
    //
}

- (void)matchEnded {
    NSLog(@"Match ended");
}

- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID {
    NSLog(@"Received data");
}

@end
