//
//  SummaryScene.m
//  PatternHunt
//
//  Created by Alp Keser on 8/26/13.
//  Copyright (c) 2013 alp keser. All rights reserved.
//

#import "SummaryScene.h"
#import "GameScene.h"
@implementation SummaryScene
@synthesize point;

- (void)didMoveToView:(SKView *)view{
    scoreView = [[UIView alloc] initWithFrame:CGRectMake(view.frame.size.width*0.1, view.frame.size.height*0.40,view.frame.size.width*0.8 , view.frame.size.height*0.3)];
    [scoreView setBackgroundColor:[UIColor blueColor]];
    [view addSubview:scoreView];
    UIButton *playAgainButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [playAgainButton addTarget:self action:@selector(setupNewGame) forControlEvents:UIControlEventTouchUpInside];
    [playAgainButton setTitle:@"Play again" forState:UIControlStateNormal];
    playAgainButton.frame = CGRectMake(scoreView.frame.size.width*0.1, scoreView.frame.size.height*0.8, scoreView.frame.size.width*0.3, scoreView.frame.size.height*0.15);//width and height should be same value
    playAgainButton.clipsToBounds = YES;
    
    playAgainButton.layer.cornerRadius = 20;//half of the width
    playAgainButton.layer.borderColor=[UIColor redColor].CGColor;
    playAgainButton.layer.borderWidth=2.0f;
    
    UIButton *mainMenuButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [mainMenuButton addTarget:self action:@selector(mainMenu) forControlEvents:UIControlEventTouchUpInside];
    [mainMenuButton setTitle:@"MainMenu" forState:UIControlStateNormal];
    mainMenuButton.frame = CGRectMake(scoreView.frame.size.width*0.6, scoreView.frame.size.height*0.8, scoreView.frame.size.width*0.3, scoreView.frame.size.height*0.15);//width and height should be same value
    mainMenuButton.clipsToBounds = YES;
    
    mainMenuButton.layer.cornerRadius = 20;//half of the width
    mainMenuButton.layer.borderColor=[UIColor redColor].CGColor;
    mainMenuButton.layer.borderWidth=2.0f;
    
    [scoreView addSubview:playAgainButton];
    [scoreView addSubview:mainMenuButton];
    
    
    
}


-(void)setupNewGame{
    SKTransition *doors = [SKTransition doorsOpenVerticalWithDuration:1];
    GameScene *gameScene = [[GameScene alloc ] initWithSize:self.size];
    [scoreView removeFromSuperview];
    [self.view presentScene:gameScene transition:doors];
}

-(void)mainMenu{
    
}

@end
