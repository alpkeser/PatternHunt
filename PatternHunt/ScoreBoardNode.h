//
//  ScoreBoardScene.h
//  PatternHunt
//
//  Created by Alp Keser on 7/29/13.
//  Copyright (c) 2013 alp keser. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface ScoreBoardNode : SKSpriteNode{
    SKLabelNode *scoreLabel;
    SKLabelNode *otherScoreLabelNode;
    //node positions
    CGPoint timeLabelPosition;
    CGPoint timePosition;
    CGPoint scoreLabelPosition;
    CGPoint scorePosition;
    
    CGPoint otherScoreLabelPosition;
    CGPoint otherScorePosition;
    float  fontSize;
    
}
@property (nonatomic,retain) SKSpriteNode *pressureBarView ;
@property (nonatomic,retain) SKLabelNode *scoreLabel;
@property (nonatomic,retain) SKLabelNode *otherScoreLabelNode;
@property (nonatomic,retain) SKScene *masterScene;
@property (nonatomic,assign) GameType gameType;
- (id)initWithColor:(UIColor *)color size:(CGSize)size andGameType:(GameType)gameType;
@end
