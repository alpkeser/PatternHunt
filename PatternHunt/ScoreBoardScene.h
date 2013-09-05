//
//  ScoreBoardScene.h
//  PatternHunt
//
//  Created by Alp Keser on 7/29/13.
//  Copyright (c) 2013 alp keser. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface ScoreBoardScene : SKSpriteNode{
    SKLabelNode *scoreLabel;
    
}
@property (nonatomic,retain) SKSpriteNode *pressureBarView ;
@property (nonatomic,retain) SKLabelNode *scoreLabel;
@property (nonatomic,retain) SKScene *masterScene;

@end
