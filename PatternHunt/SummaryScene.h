//
//  SummaryScene.h
//  PatternHunt
//
//  Created by Alp Keser on 8/26/13.
//  Copyright (c) 2013 alp keser. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SummaryScene : SKScene{
//    UIView *scoreView;
    SKSpriteNode *scoreboard;
    SKLabelNode *scoreLabelNode;
    SKLabelNode *playAgainLabelNode;
    SKLabelNode *mainMenuLabelNode;
    
}

@property (nonatomic, assign)float point;
@end
