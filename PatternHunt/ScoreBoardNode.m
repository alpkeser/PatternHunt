//
//  ScoreBoardScene.m
//  PatternHunt
//
//  Created by Alp Keser on 7/29/13.
//  Copyright (c) 2013 alp keser. All rights reserved.
//

#import "ScoreBoardNode.h"

@implementation ScoreBoardNode
@synthesize scoreLabel,pressureBarView,masterScene;

- (void)didMoveToView:(SKView *)view{

 

}
- (id)initWithColor:(UIColor *)color size:(CGSize)size{
    self = [super initWithColor:color size:size];
    if (self) {
        [self calculatePositions];
        [self addScoreBoard];
        [self addScore];
        [self addCounterLabel];
        [self addCounter];
        
    }
    return self;
}

- (void)calculatePositions{
    //yatay 10a boldum 1 gittim dikeyi 3e boldum en ustten 1 indim
    timeLabelPosition = CGPointMake(- (self.frame.size.width/10) * 2 , (self.frame.size.height / 6) );
    timePosition = CGPointMake(-(self.frame.size.height /10) * 2 , -self.frame.size.height / 6);
    
    scoreLabelPosition = CGPointMake( (self.frame.size.width/10) * 2 , (self.frame.size.height / 6) );
    scorePosition = CGPointMake((self.frame.size.width /10) * 2 , -self.frame.size.height / 6);
}
- (void)addScoreBoard{
    SKLabelNode *scoreTextLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    [scoreTextLabel setText:@"Score"];
    [scoreTextLabel setFontSize:22];
    [scoreTextLabel setPosition:scoreLabelPosition];
    //[scoreTextLabel setPosition:CGPointMake(500, 500)];
    NSLog(@"biraz debug edelim frame orginX:%f originY:%f sizeX:%f sizeY:%f",self.frame.origin.x,self.frame.origin.y,self.frame.size.width,self.frame.size.height);
    [scoreTextLabel setName:@"scoreLabelNode"];
    [self addChild:scoreTextLabel];
}

- (void)addScore{
    scoreLabel =[SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    //[[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width *0.85, 0, self.frame.size.width *0.15,aFrame.size.height )];
//    [scoreLabel setFont:[UIFont fontWithName:@"Helvetica" size:22.0f]];
//    [scoreLabel setText:@"00000"];
//    [self addSubview:scoreLabel];
    [scoreLabel setText:@"0"];
    [scoreLabel setFontSize:22];
//    [scoreLabel setPosition:CGPointMake(self.size.width/2, self.size.height/2)];
    [scoreLabel setPosition:scorePosition];
    [scoreLabel setName:@"scoreNode"];
    [self addChild:scoreLabel];
}

- (void)addCounterLabel{
    SKLabelNode *timeTextLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    [timeTextLabel setText:@"Guys gonna stop falling in"];
    [timeTextLabel setFontSize:22];
    [timeTextLabel setPosition:timeLabelPosition];
    [timeTextLabel setName:@"timeLabelNode"];
    [self addChild:timeTextLabel];
}

- (void)addCounter{
    SKLabelNode *timeLabelNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    [timeLabelNode setText:@"0.0 seconds"];
    [timeLabelNode setFontSize:22];
    [timeLabelNode setPosition:timePosition];
    [timeLabelNode setName:@"timeNode"];
    [self addChild:timeLabelNode];
}
@end
