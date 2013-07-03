//
//  MenuScene.m
//  PatternHunt
//
//  Created by alp keser on 6/25/13.
//  Copyright (c) 2013 alp keser. All rights reserved.
//

#import "MenuScene.h"
#import "GameScene.h"
@implementation MenuScene

@synthesize contentCreated;

- (void)didMoveToView:(SKView *)view{
    if (!self.contentCreated) {
        [self createSceneContents];
    }
}
- (void)createSceneContents{
    [self setBackgroundColor:[SKColor blueColor]];
    [self setScaleMode:SKSceneScaleModeAspectFit];
    [self addChild:[self newHelloNode]];
}

- (SKLabelNode*)newHelloNode{
    SKLabelNode *helloNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    [helloNode setText:@"tap to play!"];
    [helloNode setFontSize:22];
    [helloNode setPosition:CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame))];
    [helloNode setName:@"tapToPlayNode"];
    return helloNode;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    SKNode *helloNode = [self childNodeWithName:@"tapToPlayNode"];
    if (helloNode == nil) {
        return;
    }
    SKAction *moveup = [SKAction moveByX:0 y:50 duration:0.5];
    SKAction *zoom = [SKAction scaleTo:2.0 duration:0.25];
    SKAction *pause = [SKAction waitForDuration:0.5];
    SKAction *fadeAway = [SKAction fadeInWithDuration:0.25];
    SKAction *remove = [SKAction removeFromParent];
    SKAction *seq = [SKAction sequence:@[moveup,zoom,pause,fadeAway,remove]];
    [helloNode runAction:seq completion:^{
        SKScene *gameScene = [[GameScene alloc] initWithSize:self.size];
        SKTransition *doors = [SKTransition doorsOpenVerticalWithDuration:0.5];
        [self.view presentScene:gameScene transition:doors];
    }];
}
@end
