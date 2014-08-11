//
//  ScoreBoardScene.m
//  PatternHunt
//
//  Created by Alp Keser on 7/29/13.
//  Copyright (c) 2013 alp keser. All rights reserved.
//

#import "ScoreBoardNode.h"
#import "GameScene.h"
@implementation ScoreBoardNode
@synthesize scoreLabel,pressureBarView,masterScene,otherScoreLabelNode;

- (void)didMoveToView:(SKView *)view{

 

}
- (id)initWithColor:(UIColor *)color size:(CGSize)size{
    self = [super initWithColor:color size:size];
    if (self) {
        fontSize = [PHProperties fontSizeForScoreBoard];
        [self calculatePositions];
        [self addScoreBoard];
        [self addScore];
        [self addCounterLabel];
        [self addCounter];
        
        [self addOtherScore];
        [self addOtherScoreLabel];
        [self addPauseButton];
        
    }
    return self;
}

- (void)calculatePositions{
    //yatay 10a boldum 1 gittim dikeyi 3e boldum en ustten 1 indim
    timeLabelPosition = CGPointMake(- (self.frame.size.width/10) * 2 , (self.frame.size.height / 6) );
    timePosition = CGPointMake(-(self.frame.size.width /10) * 2 , -self.frame.size.height / 6);
    
    scoreLabelPosition = CGPointMake( (self.frame.size.width/10) * 1 , (self.frame.size.height / 6) );
    scorePosition = CGPointMake((self.frame.size.width /10) * 1 , -self.frame.size.height / 6);
    
    otherScoreLabelPosition = CGPointMake( (self.frame.size.width/10) * 3 , (self.frame.size.height / 6) );
    otherScorePosition = CGPointMake((self.frame.size.width /10) * 3 , -self.frame.size.height / 6);
}
- (void)addScoreBoard{
    SKLabelNode *scoreTextLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    [scoreTextLabel setText:@"Score"];
    [scoreTextLabel setFontSize:fontSize];
    [scoreTextLabel setPosition:scoreLabelPosition];
    //[scoreTextLabel setPosition:CGPointMake(500, 500)];
//    NSLog(@"biraz debug edelim frame orginX:%f originY:%f sizeX:%f sizeY:%f",self.frame.origin.x,self.frame.origin.y,self.frame.size.width,self.frame.size.height);
    [scoreTextLabel setName:@"scoreLabelNode"];
    [self addChild:scoreTextLabel];
}

- (void)addScore{
    scoreLabel =[SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    [scoreLabel setText:@"0"];
    [scoreLabel setFontSize:fontSize];
//    [scoreLabel setPosition:CGPointMake(self.size.width/2, self.size.height/2)];
    [scoreLabel setPosition:scorePosition];
    [scoreLabel setName:@"scoreNode"];
    [self addChild:scoreLabel];
}

- (void)addCounterLabel{
    SKLabelNode *timeTextLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    [timeTextLabel setText:@"Counter"];
    [timeTextLabel setFontSize:fontSize];
    [timeTextLabel setPosition:timeLabelPosition];
    [timeTextLabel setName:@"timeLabelNode"];
    [self addChild:timeTextLabel];
}

- (void)addCounter{
    SKLabelNode *timeLabelNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    [timeLabelNode setText:@"0.0 seconds"];
    [timeLabelNode setFontSize:fontSize];
    [timeLabelNode setPosition:timePosition];
    [timeLabelNode setName:@"timeNode"];
    [self addChild:timeLabelNode];
}


- (void)addOtherScoreLabel{
    SKLabelNode *otherScoreTextLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    [otherScoreTextLabel setText:@"Oppopent Score"];
    [otherScoreTextLabel setFontSize:fontSize];
    [otherScoreTextLabel setPosition:otherScoreLabelPosition];
    //[scoreTextLabel setPosition:CGPointMake(500, 500)];
    //    NSLog(@"biraz debug edelim frame orginX:%f originY:%f sizeX:%f sizeY:%f",self.frame.origin.x,self.frame.origin.y,self.frame.size.width,self.frame.size.height);
    [otherScoreTextLabel setName:@"otherScoreLabelNode"];
    [self addChild:otherScoreTextLabel];
}
- (void)addOtherScore{
    otherScoreLabelNode =[SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    //[[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width *0.85, 0, self.frame.size.width *0.15,aFrame.size.height )];
    //    [scoreLabel setFont:[UIFont fontWithName:@"Helvetica" size:22.0f]];
    //    [scoreLabel setText:@"00000"];
    //    [self addSubview:scoreLabel];
    [otherScoreLabelNode setText:@"0"];
    [otherScoreLabelNode setFontSize:fontSize];
    //    [scoreLabel setPosition:CGPointMake(self.size.width/2, self.size.height/2)];
    [otherScoreLabelNode setPosition:otherScorePosition];
    [otherScoreLabelNode setName:@"otherScoreNode"];
    [self addChild:otherScoreLabelNode];
}

- (void)addPauseButton{
    SKSpriteNode *pauseButtonNode = [[SKSpriteNode alloc] initWithImageNamed:@"pause.png"];
    [pauseButtonNode setName:@"pauseButtonNode"];
    [pauseButtonNode setSize:CGSizeMake([PHProperties pauseButtonSize], [PHProperties pauseButtonSize])];
    //loong ui codes offf
    [pauseButtonNode setPosition:CGPointMake(self.size.width*0.5 - pauseButtonNode.size.width,-self.size.height * 0.5 + pauseButtonNode.size.height )];
    
    [self addChild:pauseButtonNode];
    
    
}
@end
