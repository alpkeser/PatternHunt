//
//  SummaryScene.m
//  PatternHunt
//
//  Created by Alp Keser on 8/26/13.
//  Copyright (c) 2013 alp keser. All rights reserved.
//

#import "SummaryScene.h"
#import "GameScene.h"
#import "MenuScene.h"
#import <GameKit/GameKit.h>
@implementation SummaryScene
@synthesize point;

- (void)didMoveToView:(SKView *)view{
//    scoreView = [[UIView alloc] initWithFrame:CGRectMake(view.frame.size.width*0.1, view.frame.size.height*0.40,view.frame.size.width*0.8 , view.frame.size.height*0.3)];
//    [scoreView setBackgroundColor:[UIColor blueColor]];
//    [view addSubview:scoreView];
//    UIButton *playAgainButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [playAgainButton addTarget:self action:@selector(setupNewGame) forControlEvents:UIControlEventTouchUpInside];
//    [playAgainButton setTitle:@"Play again" forState:UIControlStateNormal];
//    playAgainButton.frame = CGRectMake(scoreView.frame.size.width*0.1, scoreView.frame.size.height*0.8, scoreView.frame.size.width*0.3, scoreView.frame.size.height*0.15);//width and height should be same value
//    playAgainButton.clipsToBounds = YES;
//    
//    playAgainButton.layer.cornerRadius = 20;//half of the width
//    playAgainButton.layer.borderColor=[UIColor redColor].CGColor;
//    playAgainButton.layer.borderWidth=2.0f;
//    
//    UIButton *mainMenuButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [mainMenuButton addTarget:self action:@selector(mainMenu) forControlEvents:UIControlEventTouchUpInside];
//    [mainMenuButton setTitle:@"MainMenu" forState:UIControlStateNormal];
//    mainMenuButton.frame = CGRectMake(scoreView.frame.size.width*0.6, scoreView.frame.size.height*0.8, scoreView.frame.size.width*0.3, scoreView.frame.size.height*0.15);//width and height should be same value
//    mainMenuButton.clipsToBounds = YES;
//    
//    mainMenuButton.layer.cornerRadius = 20;//half of the width
//    mainMenuButton.layer.borderColor=[UIColor redColor].CGColor;
//    mainMenuButton.layer.borderWidth=2.0f;
//    
//    [scoreView addSubview:playAgainButton];
//    [scoreView addSubview:mainMenuButton];
    
    //
    [self submitScore];
    
    SKSpriteNode *bgNode = [[SKSpriteNode alloc] initWithImageNamed:@"bg.png"];
    [bgNode setSize:self.size];
    [bgNode setPosition:CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame))];
    [self addChild:bgNode];
    [self setScaleMode:SKSceneScaleModeAspectFit];
    
    scoreboard = [[SKSpriteNode alloc] initWithImageNamed:@"wood_bg.jpg"];
    [scoreboard setPosition:CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame))];
    [scoreboard setSize:CGSizeMake(self.size.width * 0.6, self.size.height * 0.4)];
    [self addChild:scoreboard];
    int alp = point;
    
    //aalpk : score header node
    SKLabelNode *scoreHeaderLabelNode = [[SKLabelNode alloc] initWithFontNamed:@"Chalkduster"];
    [scoreHeaderLabelNode setText:@"Your Score"];
    [scoreHeaderLabelNode setPosition:CGPointMake(0, scoreboard.frame.size.height * 0.4)];
    [scoreboard addChild:scoreHeaderLabelNode];
    
    scoreLabelNode = [[SKLabelNode alloc] initWithFontNamed:@"Chalkduster"];
    [scoreLabelNode setText:[NSString stringWithFormat:@"%i",alp]];
    [scoreLabelNode setPosition:CGPointMake(0, scoreboard.frame.size.height * 0.3 )];
    [scoreboard addChild:scoreLabelNode];
    
    playAgainLabelNode = [[SKLabelNode alloc] initWithFontNamed:@"Chalkduster"];
    [playAgainLabelNode setText:@"Play Again!"];
    [playAgainLabelNode setPosition:CGPointMake(scoreboard.frame.size.width * -0.3, scoreboard.frame.size.height* -0.2)];
    [playAgainLabelNode setName:@"playAgainLabelNode"];
    [scoreboard addChild:playAgainLabelNode];
    
    
    mainMenuLabelNode = [[SKLabelNode alloc] initWithFontNamed:@"Chalkduster"];
    [mainMenuLabelNode setText:@"Return to Menu"];
    [mainMenuLabelNode setPosition:CGPointMake(scoreboard.frame.size.width * 0.3, scoreboard.frame.size.height *-0.2)];
    [mainMenuLabelNode setName:@"mainMenuLabelNode"];
    [scoreboard addChild:mainMenuLabelNode];
}

#pragma mark - touch methods
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    SKNode *selectedNode = [self nodeAtPoint:[(UITouch*)[touches anyObject] locationInNode:self]] ;
    if ([[selectedNode name] isEqualToString:@"playAgainLabelNode"]) {
        [self setupNewGame];
    }
    
    if ([[selectedNode name] isEqualToString:@"mainMenuLabelNode"]) {
        [self mainMenu];
    }
}

#pragma mark - navigation actions
-(void)setupNewGame{
    SKTransition *doors = [SKTransition doorsOpenVerticalWithDuration:1];
    GameScene *gameScene = [[GameScene alloc ] initWithSize:self.size];
//    [scoreView removeFromSuperview];
    [self.view presentScene:gameScene transition:doors];
}

-(void)mainMenu{
    SKTransition *doors = [SKTransition doorsOpenVerticalWithDuration:1];
    
    MenuScene *menuScene = [[MenuScene alloc ] initWithSize:self.size];
//    [scoreView removeFromSuperview];
    [self.view presentScene:menuScene transition:doors];
}

#pragma mark - gamecenter methods

- (void)submitScore{
    GKScore *score = [[GKScore alloc] initWithLeaderboardIdentifier:@"high_score_in_single"];
    
    score.value = (int64_t) point;
    
    [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
}

@end
