//
//  GameScene.m
//  PatternHunt
//
//  Created by alp keser on 6/25/13.
//  Copyright (c) 2013 alp keser. All rights reserved.
//

#import "GameScene.h"
#import "PHTileFactory.h"
#import "PHCorridor.h"
#import "LevelManager.h"
#import "SummaryScene.h"
@implementation GameScene
@synthesize contentCreated;
- (void)didMoveToView:(SKView *)view
{
    [LevelManager initLevels];

    dispatch_after( dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        //code to be executed on the main queue after delay
        [self increasePressure];
    });
    

    secondsLeft = 60.0f;
    [self setBackgroundColor:[UIColor colorWithRed:247.0f/255.0f green:175.0f/255.0f blue:29.0f/2555.0f alpha:1]];
//    SKSpriteNode *bgNode = [[SKSpriteNode alloc] initWithImageNamed:@"bg.png"];
//    SKShapeNode *shapeBgNode = [[SKShapeNode ]
//    [bgNode setSize:self.size];
//    [bgNode setPosition:CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame))];
//    [self addChild:bgNode];   
    isSceneStopped = NO;
    doesGameStarted = NO;
    factories = [[NSMutableArray alloc] init];
    PHTileFactory *aFactory = [[PHTileFactory alloc] initWithOrder:1 inFrame:self.view.frame isRunning:NO];

//    [aFactory allahinaFirlat:self];
    [factories addObject:aFactory];
    aFactory = [[PHTileFactory alloc] initWithOrder:2 inFrame:self.view.frame isRunning:YES];
 
        [factories addObject:aFactory];
    aFactory = [[PHTileFactory alloc] initWithOrder:3 inFrame:self.view.frame isRunning:YES];

        [factories addObject:aFactory];
    aFactory = [[PHTileFactory alloc] initWithOrder:4 inFrame:self.view.frame isRunning:YES];

        [factories addObject:aFactory];
    aFactory = [[PHTileFactory alloc] initWithOrder:5 inFrame:self.view.frame isRunning:YES];

        [factories addObject:aFactory];
    aFactory = [[PHTileFactory alloc] initWithOrder:6 inFrame:self.view.frame isRunning:YES];

        [factories addObject:aFactory];
    aFactory = [[PHTileFactory alloc] initWithOrder:7 inFrame:self.view.frame isRunning:YES];

        [factories addObject:aFactory];
    aFactory = [[PHTileFactory alloc] initWithOrder:8 inFrame:self.view.frame isRunning:YES];
  [factories addObject:aFactory];
    aFactory = [[PHTileFactory alloc] initWithOrder:9 inFrame:self.view.frame isRunning:YES];
  [factories addObject:aFactory];
    aFactory = [[PHTileFactory alloc] initWithOrder:10 inFrame:self.view.frame isRunning:NO];
  [factories addObject:aFactory];
    
//    PHCorridor *aCorridor = [[PHCorridor alloc] initWithOrder:1 withFrame:self.view.frame andScene:self andRunning:YES];
    //starting game after 2 secs.
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //code to be executed on the main queue after delay
        [self startGame];
    });
    
    //updating counter
    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    timer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(updateCounter) userInfo:nil repeats:YES];
    [runloop addTimer:timer forMode:NSRunLoopCommonModes];
    [runloop addTimer:timer forMode:UITrackingRunLoopMode];
    
//    //END GAME AFTER 60 SECS - removed
//    popTime = dispatch_time(DISPATCH_TIME_NOW, 62.0f * NSEC_PER_SEC); //lamest code ever
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        //code to be executed on the main queue after delay
//        [self endGame];
//    });
        [self buildInfoPanel];
    [self buildPatternPanel];
    
}
- (void)update:(NSTimeInterval)currentTime{
    CGPoint pos;
    if ([self isFinished]) {
        [self endGame];
    }
//    if ([LevelManager checkLevel:self]) {
//        [self showLevelUp];
//    }
//    int score = [scoreboardScene.scoreLabel.text intValue];
//    score++;
//    [scoreboardScene.scoreLabel setText: [NSString stringWithFormat:@"%i", score ]];
    if (isSceneStopped){
        for (UITouch *touch in touchesStack) {
//            pos = [touch locationInView: [UIApplication sharedApplication].keyWindow];
              pos = [touch locationInView: self.view];
            [self processTouchWithX:pos.x andAY:pos.y];
        }
    }else{
        for (PHTileFactory *tileFac in factories) {
            [tileFac sendNewTile:self];
        }
    }
    
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (!doesGameStarted) {
        return;
    }
    int touchId = arc4random();
    while (randomTouchId == touchId) {
        touchId = arc4random();
    }
    randomTouchId = touchId;
    [self stopScene];
    touchesStack = [[NSMutableArray alloc] init];
    selectedTiles = [[NSMutableArray alloc] init];
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //code to be executed on the main queue after delay
        [self contuniueScene:touchId];
    });
    
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if (!doesGameStarted) {
        return;
    }
    NSArray *allTouches = [touches allObjects];
    UITouch * touch = [touches anyObject];
    CGPoint pos;
    for (touch in allTouches) {
         pos = [touch locationInView: [UIApplication sharedApplication].keyWindow];
        //[self processTouchWithX:pos.x andAY:pos.y];
        [touchesStack addObject:touch];
//    NSLog(@"Position of touch: %.3f, %.3f", pos.x, pos.y);
    }

    
    
    
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (!doesGameStarted) {
        return;
    }
    if ([self checkPattern]) {
        [self clearPattern];
    }else{
        [self restartPattern];
    }
    [self runScene];
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    if (!doesGameStarted) {
        return;
    }
}

- (void)processTouchWithX:(float)aX andAY:(float)aY{

    PHTile *firstTile;
    for (PHTileFactory *factory in factories) {
        //once xsine bakıp bu boylamdamı ona gore hepsini dolasırsın
        if (factory.myTiles.count <= 0) {
            break;
        }
        firstTile = [[factory myTiles] objectAtIndex:0];
        if ([self checkX:aX inTile:firstTile]) {
            //burda kontrol et!!!
            [self checkY:aY inFactory:factory];
            //cunku burda bulduk bulduk
            return;
            
        }
        
    }
}


- (BOOL)checkX:(float)aX inTile:(PHTile*)aTile{
    float xBegin,xEnd;
    xBegin = aTile.position.x - (aTile.size.width/2);
    xEnd = aTile.position.x + (aTile.size.width/2);
    if (aX>=xBegin && aX<=xEnd) {
        return YES;
    }
    return NO;
}

- (void)checkY:(float)aY inFactory:(PHTileFactory*)factory{
    float yBegin , yEnd;
    aY = self.view.frame.size.height - aY;
    for (PHTile *tempTile in factory.myTiles) {
        if (!tempTile.isSelected) {
          
        
            yBegin = tempTile.position.y - tempTile.size.height /2;
            yEnd =tempTile.position.y + tempTile.size.height /2;
            if (aY>=yBegin && aY<=yEnd) {
//             NSLog(@" gelen aY : %f",aY);
//            NSLog(@" boyadigim tile y : %f", tempTile.position.y);
                [self selectTile:tempTile];
                return;
            }
        }
    }

}

- (void)selectTile:(PHTile*)aTile{
    
    
    //[aTile setColor:[UIColor whiteColor]];
    [aTile setTexture:[SKTexture textureWithImageNamed:@"blackTile.png"]];
    [aTile setIsSelected:YES];
    [selectedTiles addObject:aTile];
}

- (void)stopScene{
    isSceneStopped = YES;
    for (PHTileFactory* tempFac in factories) {
        [tempFac stopTheTiles];
    }
}
- (void)contuniueScene:(float)touchId{
    if (randomTouchId == touchId) {
        [self runScene];
    }
}
- (void)runScene{

    if (!isSceneStopped) {
        return;
    }
        isSceneStopped = NO;
    for (PHTileFactory* tempFac in factories) {
        if ([tempFac isRunning]) {
            [tempFac runTheTiles];
        }
        
    }
}

- (void)startGame{
    doesGameStarted = YES;
}

- (BOOL)checkPattern{
    if ([selectedTiles count] < 3) {
        return NO;
    }
    int refColorCode = [(PHTile*)[selectedTiles objectAtIndex:0] orginalColorCode];
    for(PHTile *tempTile in selectedTiles){
        if (tempTile.orginalColorCode != refColorCode) {
            return NO;
        }
    }
    return YES;
}

- (void)clearPattern{
    for(PHTile *tempTile in selectedTiles){
        [[[tempTile myFactory] myTiles] removeObject:tempTile];
        
        SKAction *moveup = [SKAction moveByX:0 y:50 duration:0.1];
        SKAction *zoom = [SKAction scaleTo:2.0 duration:0.1];
        SKAction *pause = [SKAction waitForDuration:0.1];
        SKAction *fadeAway = [SKAction fadeInWithDuration:0.1];
        SKAction *remove = [SKAction removeFromParent];
        SKAction *seq = [SKAction sequence:@[moveup,zoom,pause,fadeAway,remove]];
        [tempTile runAction:seq completion:^{
             [tempTile removeFromParent];
        }];
    }
    int addedScore =[LevelManager calculatePointWith:selectedTiles.count andLevel:1 andPressure:10];
    [self popScoreOut:[(PHTile*)[selectedTiles lastObject] position] andValue:addedScore];
    [[scoreboardNode scoreLabel] setText:[NSString stringWithFormat:@"%i",  addedScore+ [scoreboardNode.scoreLabel.text intValue]]];
}

- (void)restartPattern{
    for(PHTile *tempTile in selectedTiles){
        [tempTile setIsSelected:NO];
//        [tempTile setColor:tempTile.orginalColorCode];
       [tempTile setTexture:[SKTexture textureWithImageNamed:[PHProperties getImageNameWithNumber:tempTile.orginalColorCode]]];
    }
}

- (void)popScoreOut:(CGPoint)position andValue:(int)aValue{
    SKLabelNode *helloNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    [helloNode setText:[NSString stringWithFormat:@"%i" , aValue]];
    [helloNode setFontSize:22];
    [helloNode setPosition:position];
    [helloNode setName:@"tempScore"];
    [self addChild:helloNode];
 
    SKAction *moveup = [SKAction moveByX:0 y:50 duration:0.1];
    SKAction *zoom = [SKAction scaleTo:2.0 duration:0.1];
    SKAction *pause = [SKAction waitForDuration:0.1];
    SKAction *fadeAway = [SKAction fadeInWithDuration:0.1];
    SKAction *remove = [SKAction removeFromParent];
    SKAction *seq = [SKAction sequence:@[moveup,zoom,pause,fadeAway,remove]];
    [helloNode runAction:seq completion:^{
       
    }];
}

- (void)buildInfoPanel{
    scoreboardNode = [[ScoreBoardNode alloc] initWithColor:[UIColor colorWithRed:229.0f/255.0f green:106.0f/255.0f blue:13.0f/255.0f alpha:1]  size:CGSizeMake(self.size.width, self.size.height *0.12)];
    [scoreboardNode setMasterScene:self];
    [scoreboardNode setPosition:CGPointMake(CGRectGetMidX(self.view.frame), self.size.height-scoreboardNode.size.height /2)];
                       
                       //initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height * 0.10)];

    [self addChild:scoreboardNode];
}

- (void)buildPatternPanel{
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width *0.8, self.frame.size.height * 0.15, self.frame.size.width * 0.18, self.size.height * 0.1)];
//    [self setBackgroundColor:[UIColor blueColor]];
    [[self view]addSubview: aView];
}

- (BOOL)isFinished{
    return NO;
}

- (void)endGame{
    
    [self stopScene];
    SKLabelNode *helloNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    [helloNode setText:@"Game Over!!"];
    [helloNode setFontSize:22];
    [helloNode setPosition:CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame))];
    [self addChild:helloNode];
    
    SKAction *moveup = [SKAction moveByX:0 y:50 duration:0.5];
    SKAction *zoom = [SKAction scaleTo:2.0 duration:0.25];
    SKAction *pause = [SKAction waitForDuration:0.5];
//    SKAction *fadeAway = [SKAction fadeInWithDuration:0.25];
//    SKAction *remove = [SKAction removeFromParent];
//    SKAction *seq = [SKAction sequence:@[moveup,zoom,pause,fadeAway,remove]];
    SKAction *seq = [SKAction sequence:@[moveup,zoom,pause]];
    [helloNode runAction:seq completion:^{
        SummaryScene *gameScene = [[SummaryScene alloc] initWithSize:self.size];
        SKTransition *doors = [SKTransition doorsOpenVerticalWithDuration:0.5];
        [self.view presentScene:gameScene transition:doors];
    }];
}

- (void)increasePressure{
    //sabit var burda da
    [LevelManager increasePressure:10];
    dispatch_after( dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        //code to be executed on the main queue after delay
        [self increasePressure];
    });
}

- (void)showLevelUp{
    SKLabelNode *helloNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    [helloNode setText:[NSString stringWithFormat:@"Level %i",[LevelManager getLevel]] ];
    [helloNode setFontSize:22];
    [helloNode setPosition:CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame))];
    [self addChild:helloNode];
    
    SKAction *moveup = [SKAction moveByX:0 y:50 duration:0.5];
    SKAction *zoom = [SKAction scaleTo:2.0 duration:0.25];
    SKAction *pause = [SKAction waitForDuration:0.5];
        SKAction *fadeAway = [SKAction fadeInWithDuration:0.25];
        SKAction *remove = [SKAction removeFromParent];
        SKAction *seq = [SKAction sequence:@[moveup,zoom,pause,fadeAway,remove]];
//    SKAction *seq = [SKAction sequence:@[moveup,zoom,pause]];
//    [helloNode runAction:seq completion:^{
//        SummaryScene *gameScene = [[SummaryScene alloc] initWithSize:self.size];
//        SKTransition *doors = [SKTransition doorsOpenVerticalWithDuration:0.5];
//        [self.view presentScene:gameScene transition:doors];
//    }];

}

- (void)updateCounter{
    secondsLeft = secondsLeft - 0.1f ;
    if (secondsLeft < 0.0f) {
        [timer invalidate];
        [self endGame];
        return;
        
    }
    SKLabelNode *timeNode = (SKLabelNode*)[scoreboardNode childNodeWithName:@"timeNode"];
    [timeNode setText:[NSString stringWithFormat:@"%.01f seconds",secondsLeft]];
}

@end
