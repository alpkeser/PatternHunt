//
//  ViewController.m
//  PatternHunt
//
//  Created by alp keser on 6/24/13.
//  Copyright (c) 2013 alp keser. All rights reserved.
//

#import "ViewController.h"
#import <SpriteKit/SpriteKit.h>
#import "MenuScene.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    SKView *spriteView = (SKView*)self.view;
    [spriteView setShowsDrawCount:YES];
    [spriteView setShowsNodeCount:YES];
    [spriteView setShowsFPS:YES];
}


- (void)viewWillAppear:(BOOL)animated{
    MenuScene *menuScene = [[MenuScene alloc] initWithSize:self.view.frame.size];
    SKView *myView = (SKView*) self.view;
    [myView presentScene:menuScene];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
