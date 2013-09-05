//
//  ScoreBoardScene.m
//  PatternHunt
//
//  Created by Alp Keser on 7/29/13.
//  Copyright (c) 2013 alp keser. All rights reserved.
//

#import "ScoreBoardScene.h"

@implementation ScoreBoardScene
@synthesize scoreLabel,pressureBarView,masterScene;

- (void)didMoveToView:(SKView *)view{

 

}
- (id)initWithColor:(UIColor *)color size:(CGSize)size{
    self = [super initWithColor:color size:size];
    if (self) {
        [self addScoreBoard];
        [self addScore];
    }
    return self;
}
- (void)addScoreBoard{
    SKLabelNode *scoreTextLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    [scoreTextLabel setText:@"Score"];
    [scoreTextLabel setFontSize:22];
    [scoreTextLabel setPosition:CGPointMake((self.position.x/2)*3,(self.position.y)*3)];
    //[scoreTextLabel setPosition:CGPointMake(500, 500)];
    NSLog(@"biraz debug edelim frame orginX:%f originY:%f sizeX:%f sizeY:%f",self.frame.origin.x,self.frame.origin.y,self.frame.size.width,self.frame.size.height);
    [scoreTextLabel setName:@"scoreLabelNode"];
    [self.masterScene addChild:scoreTextLabel];
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
    [scoreLabel setPosition:CGPointMake(self.size.width/4,0)];
    [scoreLabel setName:@"scoreNode"];
    [self addChild:scoreLabel];
}

@end
