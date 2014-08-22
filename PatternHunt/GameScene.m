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
#import "MenuScene.h"


#define kMenuButtonSizeRatio 0.15
#define kGameOverButtonSizeRatio 0.10



@implementation GameScene
@synthesize contentCreated;
#pragma mark - SKScene event methods
- (void)didMoveToView:(SKView *)view
{
    [[self view] setMultipleTouchEnabled:NO];
    [self setIsFinished:NO];
    [self setIsPaused:NO];
    [LevelManager initLevels];
    [self setupCountDown];
    self.traces = [NSMutableArray new];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),^(void){
       self.nextGameScene = [[GameScene alloc] initWithSize:self.size];
    });
//    dispatch_after( dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
//        //code to be executed on the main queue after delay
//        [self increasePressure];
//    });
//    

    secondsLeft = 33.0; //3 sec for begining
//    [self setBackgroundColor:[UIColor colorWithRed:247.0f/255.0f green:175.0f/255.0f blue:29.0f/2555.0f alpha:1]];
//    [self setBackgroundColor:[UIColor blackColor]];
    SKSpriteNode *bgNode = [[SKSpriteNode alloc] initWithImageNamed:@"background.png"];
    [bgNode setSize:self.size];
    [bgNode setPosition:CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame))];
    [bgNode setZPosition:-5.0f];
    [self addChild:bgNode];   
    isSceneStopped = NO;
    doesGameStarted = NO;
    if (_factories == nil) {
        _factories = [self setupFactoriesWithFrame:self.view.frame];
    }
   
    
//    PHCorridor *aCorridor = [[PHCorridor alloc] initWithOrder:1 withFrame:self.view.frame andScene:self andRunning:YES];
    //starting game after 2 secs.
    double delayInSeconds = 3.0;
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
    [[GCHelper sharedInstance] setDelegate:self];
}

- (NSMutableArray*)setupFactoriesWithFrame:(CGRect)aFrame{
    NSMutableArray *someFactories = [[NSMutableArray alloc] init];
    PHTileFactory *aFactory = [[PHTileFactory alloc] initWithOrder:1 inFrame:aFrame isRunning:YES];
    
    
    [someFactories addObject:aFactory];
    aFactory = [[PHTileFactory alloc] initWithOrder:2 inFrame:aFrame isRunning:YES];
    
    [someFactories addObject:aFactory];
    aFactory = [[PHTileFactory alloc] initWithOrder:3 inFrame:aFrame isRunning:YES];
    
    [someFactories addObject:aFactory];
    aFactory = [[PHTileFactory alloc] initWithOrder:4 inFrame:aFrame isRunning:YES];
    
    [someFactories addObject:aFactory];
    aFactory = [[PHTileFactory alloc] initWithOrder:5 inFrame:aFrame isRunning:YES];
    
    [someFactories addObject:aFactory];
    aFactory = [[PHTileFactory alloc] initWithOrder:6 inFrame:aFrame isRunning:YES];
    
    [someFactories addObject:aFactory];
    aFactory = [[PHTileFactory alloc] initWithOrder:7 inFrame:aFrame isRunning:YES];
    
    [someFactories addObject:aFactory];
    aFactory = [[PHTileFactory alloc] initWithOrder:8 inFrame:aFrame isRunning:YES];
    [someFactories addObject:aFactory];
    aFactory = [[PHTileFactory alloc] initWithOrder:9 inFrame:aFrame isRunning:YES];
    [someFactories addObject:aFactory];
    aFactory = [[PHTileFactory alloc] initWithOrder:10 inFrame:aFrame isRunning:YES];
    [someFactories addObject:aFactory];
    return someFactories;
}
- (void)setFactoriesFromColorCodes:(int[10][300])colorCodes andWithFrame:(CGRect)aFrame{
    PHTileFactory *aFactory;
    _factories = [NSMutableArray new];
    for (int sayac = 0; sayac<10; sayac++) {
          aFactory = [[PHTileFactory alloc] initWithOrder:sayac+1 inFrame:aFrame isRunning:YES andColorCodes:colorCodes[sayac]];
        [_factories addObject:aFactory];
    }
}
- (void)update:(NSTimeInterval)currentTime{
    CGPoint pos;
    if ([self isFinished] || self.isPaused) {
        return;
    }

    if (isSceneStopped){
        for (UITouch *touch in touchesStack) {
//            PHTile *aTile = (PHTile*)[self nodeAtPoint:[touch locationInNode:self]];
            NSArray *nodes = [self nodesAtPoint:[touch locationInNode:self]];
            for (SKNode *tempNode in nodes) {
                if ([tempNode isKindOfClass:[PHTile class]] && ![(PHTile*)tempNode isSelected]) {
                   [self selectTile:(PHTile*)tempNode];
                }
            }
            
              pos = [touch locationInView: self.view];
//            [self processTouchWithX:pos.x andAY:pos.y]; //-aalpk
//            [self selectTile:(PHTile*)[self nodeAtPoint:pos]];
        }
    }else{
        PHTileFactory *aTileFactory = [_factories objectAtIndex:0];//temp aalpk
        if ([aTileFactory shouldSendNewTile]) {
            for (PHTileFactory *tileFac in _factories) {
                [tileFac sendNewTile:self];
            }
        }
        
    }
    
    
}

- (void)runFactory{
    CGPoint pos;
    if ([self isFinished] || self.isPaused) {
        return;
    }
    
    if (isSceneStopped){
        for (UITouch *touch in touchesStack) {
            //            PHTile *aTile = (PHTile*)[self nodeAtPoint:[touch locationInNode:self]];
            NSArray *nodes = [self nodesAtPoint:[touch locationInNode:self]];
            for (SKNode *tempNode in nodes) {
                if ([tempNode isKindOfClass:[PHTile class]] && ![(PHTile*)tempNode isSelected]) {
                    [self selectTile:(PHTile*)tempNode];
                }
            }
            
            pos = [touch locationInView: self.view];
            //            [self processTouchWithX:pos.x andAY:pos.y]; //-aalpk
            //            [self selectTile:(PHTile*)[self nodeAtPoint:pos]];
        }
    }else{
        PHTileFactory *aTileFactory = [_factories objectAtIndex:0];//temp aalpk
        if ([aTileFactory shouldSendNewTile]) {
            for (PHTileFactory *tileFac in _factories) {
                [tileFac sendNewTile:self];
            }
        }
        
    }
 
}
#pragma mark - begining animations

- (void)setupCountDown{
    SKSpriteNode *blackSurface = [[ SKSpriteNode alloc] initWithColor:[UIColor blackColor] size:self.size];
    [blackSurface setZPosition:2.0f];
    [blackSurface setAlpha:0.6f];
    [blackSurface setSize:self.size];
    [blackSurface setPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))];
    [blackSurface setName:@"blackSurfaceNode"];
    [self addChild:blackSurface];
    [self countDown:3];
    [self performSelector:@selector(removeBlackSurface) withObject:nil afterDelay:3.0f];
    //we have 3 sec in total 4 label 3,2,1,go so 0.75 for each duration
//        [self performSelector:@selector(countDown) withObject:nil afterDelay:0.75];
    
    
    
}
- (void)countDown:(int)newValue{
    SKNode *blackSurface = [self childNodeWithName:@"blackSurfaceNode"];
    SKLabelNode *countDownNode = [SKLabelNode labelNodeWithFontNamed:@"CarterOne"];
    if (newValue<=0) {
        [countDownNode setText:@"Go!!"];
    }else{
        [countDownNode setText:[NSString stringWithFormat:@"%i" , newValue]];
    }
    
    [countDownNode setFontSize:[PHProperties fontSizeForGameScene]];
    [countDownNode setPosition:CGPointMake(0, 0)];
//    [countDownNode setName:@"countDownNode"];
    [blackSurface addChild:countDownNode];


    SKAction *moveup = [SKAction moveByX:0 y:50 duration:0.2];
    SKAction *zoom = [SKAction scaleTo:2.0 duration:0.2];
    SKAction *pause = [SKAction waitForDuration:0.1];
    SKAction *fadeAway = [SKAction fadeInWithDuration:0.25];
    newValue--;
    [countDownNode runAction:[SKAction sequence:@[moveup,zoom,pause,fadeAway]] completion:^(void){
        [countDownNode removeFromParent];
        if (newValue>=0) {
            [self countDown:newValue];
        
        }else{

        }
    }];
    
}

- (void)removeBlackSurface{
    SKAction *fadeAway = [SKAction fadeAlphaTo:0 duration:0.4];
    SKNode *node = [self childNodeWithName:@"blackSurfaceNode"];
    [node runAction:fadeAway completion:^(void){
        [node removeFromParent];
    }];
}

#pragma mark - touch delegates
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    if (!doesGameStarted ) {
        return;
    }
    if (self.isPaused || self.isFinished) {
        if ( [[(SKNode*)[self nodeAtPoint:[(UITouch*)[touches anyObject] locationInNode:self]] name] isEqualToString:@"playButtonNode"] ) {
            if (self.gameType == SINGLE) {
                [self setIsPaused:NO];
                [self runScene];
                [self removePauseMenu];
                return;
            }
            
        }else if ([[(SKNode*)[self nodeAtPoint:[(UITouch*)[touches anyObject] locationInNode:self]] name] isEqualToString:@"restartButtonNode"]){
            SKTransition *doors = [SKTransition doorsOpenVerticalWithDuration:0.5];
            [self.view presentScene:self.nextGameScene transition:doors];

        }else if ([[(SKNode*)[self nodeAtPoint:[(UITouch*)[touches anyObject] locationInNode:self]] name] isEqualToString:@"quitButtonNode"]){
            SKTransition *doors = [SKTransition doorsOpenVerticalWithDuration:1];
            
            MenuScene *menuScene = [[MenuScene alloc ] initWithSize:self.size];
            //    [scoreView removeFromSuperview];
            [self.view presentScene:menuScene transition:doors];
            
        }
        
        return;
    }
    if ( [[(SKNode*)[self nodeAtPoint:[(UITouch*)[touches anyObject] locationInNode:self]] name] isEqualToString:@"pauseButtonNode"] ) {
        if (self.gameType == SINGLE) {
            [self setIsPaused:YES];
            [self stopScene];
            [self showPauseMenu];
            return;
        }
        
    }
    if (!self.fingerTrace) {
            [self traceBeginFromPoint:[[touches allObjects] objectAtIndex:0]];
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
    if (!doesGameStarted || self.isFinished || self.isPaused) {
        return;
    }
    NSArray *allTouches = [touches allObjects];
    UITouch * touch = [touches anyObject];
    CGPoint pos;
    [self addTraceWithTouch:[allTouches firstObject]];
    
    for (touch in allTouches) {
         pos = [touch locationInView: [UIApplication sharedApplication].keyWindow];
        //[self processTouchWithX:pos.x andAY:pos.y];
        [touchesStack addObject:touch];
//    NSLog(@"Position of touch: %.3f, %.3f", pos.x, pos.y);
    }

    
    
    
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if (!doesGameStarted || self.isFinished || self.isPaused) {
        return;
    }

    int numberOfTiles = [self checkPattern];
    if (numberOfTiles>0) {
        [self finishTraceWithSucess:YES andNumberOfTiles:[NSNumber numberWithInt:numberOfTiles]];
        [self clearPattern];
        
    }else{
        [self finishTraceWithSucess:NO andNumberOfTiles:nil];
        [self restartPattern];
    }
    [self runScene];
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    if (!doesGameStarted || self.isFinished) {
        return;
    }
}
#pragma mark - TouchTrace Methods

- (void)traceBeginFromPoint:(UITouch*)beginTouch{
    UIColor* fillColor = [UIColor colorWithRed: 0.114 green: 0.705 blue: 1 alpha: 1];
    UIColor* strokeColor = [UIColor colorWithRed: 0 green: 0.295 blue: 0.886 alpha: 1];
    strokeColor = [UIColor redColor];
    CGPoint beginPoint = [beginTouch locationInNode:self];
    CGPathRef cgPath;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, beginPoint.x, beginPoint.y);

    cgPath = CGPathCreateCopy(path);


    self.fingerTrace = [[SKShapeNode alloc] init];
    [self.fingerTrace setPath:cgPath];
//    [self.fingerTrace setFillColor:fillColor];
    [self.fingerTrace setStrokeColor:fillColor];
    [self.fingerTrace setLineWidth:[PHProperties sizeForTraceStroke]];
    [self.fingerTrace setGlowWidth:1.0f];
    [self.fingerTrace setAntialiased:YES];
    [self addChild:self.fingerTrace];
        CGPathRelease(path);
        CGPathRelease(cgPath);
}
- (void)addTraceWithTouch:(UITouch*)aTouch{
    CGPoint additionPoint = [aTouch locationInNode:self];
//    NSLog(@"x:%f y: %f",additionPoint.x,additionPoint.y);
    CGMutablePathRef mutablePath = CGPathCreateMutableCopy(self.fingerTrace.path);
    CGPathAddLineToPoint(mutablePath, nil, additionPoint.x, additionPoint.y);
    [self.fingerTrace setPath:CGPathCreateCopy(mutablePath)];
    CGPathRelease(mutablePath);
    
}

- (void)finishTraceWithSucess:(BOOL)isSucess andNumberOfTiles:(NSNumber*)numberOfTiles{
    if (!self.fingerTrace) {
        return;
    }
    if (!self.fingerTrace.userData) {
        [self.fingerTrace setUserData:[NSMutableDictionary new]];
    }
    if (isSucess) {
        [self.fingerTrace.userData setValue:@"0" forKey:@"isSucess"];
        [self.fingerTrace.userData setValue:numberOfTiles forKey:@"numberOfTiles"];
        [self.fingerTrace.userData setValue:[NSNumber numberWithInt:[LevelManager calculatePointWith:[numberOfTiles intValue] andLevel:1 andPressure:10]] forKey:@"points"];
    }else{
        [self.fingerTrace.userData setValue:@"1" forKey:@"isSucess"];
    }
    [self.traces addObject:self.fingerTrace];
//    [self.fingerTrace removeFromParent];
    [self.fingerTrace setZPosition:-1.0f];
    [self.fingerTrace setAlpha:0.1f];
    self.fingerTrace = nil;
//    [self insertChild:self.fingerTrace atIndex:self.children.count-1];
    
    
    
}
- (SKShapeNode*)findWinnerTrace{
    if (self.traces.count == 0) {
        return nil;
    }
    SKShapeNode *winnerTrace;
    for (SKShapeNode *tempNode in self.traces) {
        if ([tempNode.userData[@"isSucess"] isEqualToString:@"0"]) {
            if (winnerTrace == nil) {
                winnerTrace = tempNode;
            }else{
                if ([(NSNumber*)tempNode.userData[@"numberOfTiles"] intValue] > [(NSNumber*)winnerTrace.userData[@"numberOfTiles"] intValue]) {
                winnerTrace = tempNode;
                }
            }
        }
    }
    return winnerTrace;
}

- (void)showLongestPattern{
//    SKShapeNode 
}
#pragma mark - custom code
- (void)updateCounter{
    if (self.isPaused) {
        return;
    }
    //    [self runFactory];
    secondsLeft = secondsLeft - 0.1f ;
    if (secondsLeft < 0.0f) {
        [timer invalidate];
        [self endGame];
        return;
    }
    SKLabelNode *timeNode = (SKLabelNode*)[scoreboardNode childNodeWithName:@"timeNode"];
    [timeNode setText:[NSString stringWithFormat:@"%.01f seconds",secondsLeft]];
}

- (void)processTouchWithX:(float)aX andAY:(float)aY{
//
    PHTile *firstTile;
//    self nodeAtPoint:CGPointMake(CGFloat x, <#CGFloat y#>)
    for (PHTileFactory *factory in _factories) {
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
    
    if (aTile == nil) {
        return;
    }
    [aTile setTexture:[SKTexture textureWithImageNamed:@"blackTile.png"]];
    //shake action
    SKAction *rightRotate = [SKAction rotateByAngle:10.0f duration:0.1];
    SKAction *leftRotate = [SKAction rotateByAngle:-10.0f duration:0.1];
    SKAction *shake = [SKAction sequence:@[rightRotate,leftRotate,leftRotate,rightRotate]];
    [aTile runAction:[SKAction repeatActionForever:shake]];
    [aTile setIsSelected:YES];
    //trace color check

    if (selectedTiles.count > 0) {
        PHTile * lastTile = (PHTile*)[selectedTiles lastObject];
        if (lastTile.orginalColorCode != aTile.orginalColorCode) {
            [self.fingerTrace setStrokeColor:[UIColor   redColor]];
        }
    }
    [selectedTiles addObject:aTile];
    
}

- (void)stopScene{
    isSceneStopped = YES;
    for (PHTileFactory* tempFac in _factories) {
        [tempFac stopTheTiles];
    }
}
- (void)contuniueScene:(float)touchId{
    if (randomTouchId == touchId) {
        [self runScene];
    }
}
- (void)runScene{

    if (!isSceneStopped || self.isPaused) {
        return;
    }
        isSceneStopped = NO;
    for (PHTileFactory* tempFac in _factories) {
        if ([tempFac isRunning]) {
            [tempFac runTheTiles];
        }
        
    }
}

- (void)startGame{
    doesGameStarted = YES;
}

- (int)checkPattern{
    if ([selectedTiles count] < 3) {
        return 0;
    }
    int numberOfTiles = 0;
    int refColorCode = [(PHTile*)[selectedTiles objectAtIndex:0] orginalColorCode];
    for(PHTile *tempTile in selectedTiles){
        numberOfTiles++;
        if (tempTile.orginalColorCode != refColorCode) {
            return 0;
        }
    }
    return numberOfTiles;
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
    if (self.gameType == MULTIPLAYER) {
        [self sendPointsToOpponent:([scoreboardNode.scoreLabel.text intValue] )];
    }
}

- (void)restartPattern{
    for(PHTile *tempTile in selectedTiles){
        [tempTile setIsSelected:NO];
        [tempTile removeAllActions];
        [tempTile runAction:[SKAction rotateToAngle:0 duration:0]];
//        [tempTile setColor:tempTile.orginalColorCode];
       [tempTile setTexture:[SKTexture textureWithImageNamed:[PHProperties getImageNameWithNumber:tempTile.orginalColorCode]]];
    }
}

- (void)popScoreOut:(CGPoint)position andValue:(int)aValue{
    SKLabelNode *helloNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    [helloNode setText:[NSString stringWithFormat:@"%i" , aValue]];
    [helloNode setFontSize:[PHProperties fontSizeForGameScene]];
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
    [scoreboardNode setZPosition:2.0f];
    [self addChild:scoreboardNode];
}

- (void)buildPatternPanel{
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width *0.8, self.frame.size.height * 0.15, self.frame.size.width * 0.18, self.size.height * 0.1)];
//    [self setBackgroundColor:[UIColor blueColor]];
    [[self view]addSubview: aView];
}
#pragma mark - Pause Menu
- (void) showPauseMenu{
    SKSpriteNode *menuBackgroundNode = [[SKSpriteNode alloc] initWithImageNamed:@"pauseMenu.png"];
    [menuBackgroundNode  setSize:CGSizeMake(self.frame.size.width * 0.8, self.frame.size.width * 0.4)];
    [menuBackgroundNode setPosition:CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.7 )];
    [menuBackgroundNode setName:@"pauseMenuNode"];
    [self addChild:menuBackgroundNode];
    
    //0.955 more height
    SKSpriteNode *playNode = [[SKSpriteNode alloc] initWithImageNamed:@"playButton.png"];
    [playNode setSize:CGSizeMake(menuBackgroundNode.size.width * kMenuButtonSizeRatio, menuBackgroundNode.size.width * kMenuButtonSizeRatio * 0.955)];
    [playNode setPosition:CGPointMake(menuBackgroundNode.size.width * -0.25, -menuBackgroundNode.size.height * 0.10)];//CGRectGetMidY(menuBackgroundNode.frame
    [playNode setName:@"playButtonNode"];
    [menuBackgroundNode addChild:playNode];
    
    SKSpriteNode *restartNode = [[SKSpriteNode alloc] initWithImageNamed:@"restartButton.png"];
    [restartNode setSize:CGSizeMake(menuBackgroundNode.size.width * kMenuButtonSizeRatio, menuBackgroundNode.size.width * kMenuButtonSizeRatio * 0.955)];
    [restartNode setPosition:CGPointMake(0, 0)];
    [restartNode setName:@"restartButtonNode"];
    [menuBackgroundNode addChild:restartNode];
    
    SKSpriteNode *quitNode = [[SKSpriteNode alloc] initWithImageNamed:@"menuButton.png"];
    [quitNode setSize:CGSizeMake(menuBackgroundNode.size.width * kMenuButtonSizeRatio, menuBackgroundNode.size.width * kMenuButtonSizeRatio * 0.955)];
    [quitNode setPosition:CGPointMake(menuBackgroundNode.size.width * +0.25, -menuBackgroundNode.size.height * 0.10)];
    [quitNode setName:@"quitButtonNode"];
    [menuBackgroundNode addChild:quitNode];
}

- (void)removePauseMenu{
    [[self childNodeWithName:@"pauseMenuNode"] removeFromParent];
}

#pragma mark - Game End Methods
- (void)endGame{
    [self setIsFinished:YES];
    if (self.fingerTrace) {
        [self.fingerTrace removeFromParent];
    }
    [self stopScene];
    [self clearScene];
    SKLabelNode *helloNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    [helloNode setText:@"Game Over!!"];
    [helloNode setFontSize:[PHProperties fontSizeForGameScene]];
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
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),^(void){
            while (self.traces.count !=0) {
                
            }
            dispatch_async(dispatch_get_main_queue(), ^(void){
                //            [self showBestPatternWithWinnerTrace:winnerTrace];
                [self showGameOverPanel];
            });
        });
        [self riseAndFallAnimationWithWinnerTrace:[self findWinnerTrace]];
    }];
}

- (void)clearScene{
    
    SKAction *fadeAway = [SKAction fadeOutWithDuration:0.1];
    
    //    SKAction *seq = [SKAction sequence:@[moveup,zoom,pause,fadeAway,remove]];
    
    for (PHTileFactory *tempFactory in self.factories){
        for (PHTile *tempTile in tempFactory.myTiles) {
            [tempTile runAction:fadeAway];
        }
    }
    
    
}

- (void)riseAndFallAnimationWithWinnerTrace:(SKShapeNode*)winnerTrace{
    
    float timeUnit = 2.0f  / self.traces.count;
    SKAction *shine = [SKAction fadeAlphaTo:0.5f duration:0.3 * timeUnit];
    SKAction *shineMore = [SKAction sequence:@[[SKAction fadeAlphaTo:1.0f duration:1 ]]];
    SKAction *fall = [SKAction fadeAlphaTo:0.1f duration:0.2 * timeUnit ];
    
    SKShapeNode*tempTile = self.traces.firstObject;

        [self.traces removeObject:tempTile];
    [tempTile runAction:shine completion:^(void){

        if (tempTile == winnerTrace) {
            [tempTile runAction:shineMore];
        }else{
            [tempTile runAction:fall];
        }

        if (self.traces.count!=0) {
            [self riseAndFallAnimationWithWinnerTrace:winnerTrace];
        }else{

        }
    }];
    
}

- (void)showGameOverPanel{
    SKSpriteNode *blackSurface = [[ SKSpriteNode alloc] initWithColor:[UIColor blackColor] size:self.size];
    [blackSurface setZPosition:2.0f];
    [blackSurface setAlpha:0.6f];
    [blackSurface setSize:self.size];
    [blackSurface setPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))];
    [blackSurface setName:@"blackSurfaceNode"];
    [self addChild:blackSurface];
    SKSpriteNode *gameOverPanel = [[SKSpriteNode alloc] initWithImageNamed:@"gameover.png"];
    //ratio is 1.803
    [gameOverPanel setSize:CGSizeMake(self.frame.size.width * 0.8, self.frame.size.width * 0.8 / 1.803)];
    [gameOverPanel setPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + blackSurface.frame.size.height * 0.1)];
    [gameOverPanel setZPosition:5.0f];
    [gameOverPanel setName:@"gameOverPanel"];
    [self addChild:gameOverPanel];
    
    //pane stuffs
    //total point
    SKLabelNode *totalPointsLabel = [[SKLabelNode alloc] initWithFontNamed:@"CarterOne"];
    [totalPointsLabel setFontSize:[PHProperties fontSizeForGameScene]];
    [totalPointsLabel setPosition:CGPointMake(0, gameOverPanel.frame.size.height * -0.10)];
    [totalPointsLabel setText:[NSString stringWithFormat:@"Total Score: %i",[scoreboardNode.scoreLabel.text intValue]]];
    [gameOverPanel addChild:totalPointsLabel];
    //Longest
    SKLabelNode *longestPatternLabel = [[SKLabelNode alloc] initWithFontNamed:@"CarterOne"];
    [longestPatternLabel setFontSize:[PHProperties fontSizeForGameScene]];
    [longestPatternLabel setPosition:CGPointMake(0, gameOverPanel.frame.size.height * -0.30)];
    [longestPatternLabel setText:[NSString stringWithFormat:@"Longest Pattern: %i",[scoreboardNode.scoreLabel.text intValue]]];
    [gameOverPanel addChild:longestPatternLabel];
    
    //stars
    
    //first empty stars
    SKSpriteNode *leftEmptyStar = [[SKSpriteNode alloc] initWithImageNamed:@"leftStarEmpty.png"];
    //lets say
    [leftEmptyStar setSize:CGSizeMake(gameOverPanel.frame.size.width * 0.08, gameOverPanel.frame.size.width * 0.08)];
    [leftEmptyStar setPosition:CGPointMake(-gameOverPanel.frame.size.width * 0.15, gameOverPanel.frame.size.height* 0.08)];
    [gameOverPanel addChild:leftEmptyStar];
    
    SKSpriteNode *centerEmptyStar = [[SKSpriteNode alloc] initWithImageNamed:@"centerStarEmpty.png"];
    [centerEmptyStar setSize:CGSizeMake(gameOverPanel.frame.size.width * 0.1, gameOverPanel.frame.size.width * 0.1)];
    [centerEmptyStar setPosition:CGPointMake(0, gameOverPanel.frame.size.height* 0.12)];
    [gameOverPanel addChild:centerEmptyStar];
    
    SKSpriteNode *rightEmptyStar = [[SKSpriteNode alloc] initWithImageNamed:@"rightStarEmpty.png"];
    [rightEmptyStar  setSize:CGSizeMake(gameOverPanel.frame.size.width * 0.08, gameOverPanel.frame.size.width * 0.08)];
    
    [rightEmptyStar setPosition:CGPointMake(+gameOverPanel.frame.size.width * 0.15, gameOverPanel.frame.size.height* 0.08)];
    [gameOverPanel addChild:rightEmptyStar];
    [self performSelector:@selector(playLeftStarAnimation) withObject:nil afterDelay:0.3f];
    
    //buttons
    SKSpriteNode *restartNode = [[SKSpriteNode alloc] initWithImageNamed:@"restartButton.png"];
    [restartNode setSize:CGSizeMake(gameOverPanel.size.width * kGameOverButtonSizeRatio, gameOverPanel.size.width * kGameOverButtonSizeRatio * 0.955)];
    [restartNode setPosition:CGPointMake(-gameOverPanel.frame.size.width * 0.10, -gameOverPanel.frame.size.height * 0.45)];
    [restartNode setName:@"restartButtonNode"];
    [gameOverPanel addChild:restartNode];
    
    SKSpriteNode *quitNode = [[SKSpriteNode alloc] initWithImageNamed:@"menuButton.png"];
    [quitNode setSize:CGSizeMake(gameOverPanel.size.width * kGameOverButtonSizeRatio, gameOverPanel.size.width * kGameOverButtonSizeRatio * 0.955)];
    [quitNode setPosition:CGPointMake(gameOverPanel.size.width * +0.10, -gameOverPanel.size.height * 0.45)];
    [quitNode setName:@"quitButtonNode"];
    [gameOverPanel addChild:quitNode];
    
    
    
}

- (void)playLeftStarAnimation{
    //star animations
    //todo add switch
    SKSpriteNode *gameOverPanel = (SKSpriteNode*)[self childNodeWithName:@"gameOverPanel"];
    if (!gameOverPanel) {
        return;
    }
    SKSpriteNode *leftFullStar = [[SKSpriteNode alloc] initWithImageNamed:@"leftStarFull.png"];
    [leftFullStar setSize:CGSizeMake(gameOverPanel.frame.size.width * 0.16, gameOverPanel.frame.size.width * 0.16)];
    [leftFullStar setPosition:CGPointMake(-gameOverPanel.frame.size.width * 0.15, gameOverPanel.frame.size.height* 0.28)];
    [leftFullStar   setAlpha:0.0f];
    [gameOverPanel addChild:leftFullStar];
    SKAction *scaleDown = [SKAction scaleTo:0.5 duration:0.3];
    SKAction *moveDown = [SKAction moveToY:gameOverPanel.frame.size.height* 0.08 duration:0.3];
    SKAction *fadeIn = [SKAction fadeAlphaTo:1.0f duration:0.3];
    SKAction *allActions = [SKAction group:@[scaleDown,moveDown,fadeIn]];
    
    [leftFullStar runAction:allActions completion:^(void){
        [self performSelector:@selector(playCenterStarAnimation) withObject:nil afterDelay:0.2];
    }];
}

- (void)playCenterStarAnimation{
    //star animations
    //todo add switch
    SKSpriteNode *gameOverPanel = (SKSpriteNode*)[self childNodeWithName:@"gameOverPanel"];
    if (!gameOverPanel) {
        return;
    }
    SKSpriteNode *centerFullStar = [[SKSpriteNode alloc] initWithImageNamed:@"centerStarFull.png"];
    [centerFullStar setSize:CGSizeMake(gameOverPanel.frame.size.width * 0.2, gameOverPanel.frame.size.width * 0.2)];
    [centerFullStar setPosition:CGPointMake(0, gameOverPanel.frame.size.height* 0.32)];
    [centerFullStar   setAlpha:0.0f];
    [gameOverPanel addChild:centerFullStar];
    SKAction *scaleDown = [SKAction scaleTo:0.5 duration:0.3];
    SKAction *moveDown = [SKAction moveToY:gameOverPanel.frame.size.height* 0.12 duration:0.3];
    SKAction *fadeIn = [SKAction fadeAlphaTo:1.0f duration:0.3];
    SKAction *allActions = [SKAction group:@[scaleDown,moveDown,fadeIn]];
    
    [centerFullStar runAction:allActions completion:^(void){
        [self performSelector:@selector(playRightStarAnimation) withObject:nil afterDelay:0.2];
    }];
}

- (void)playRightStarAnimation{
    //star animations
    //todo add switch
    SKSpriteNode *gameOverPanel = (SKSpriteNode*)[self childNodeWithName:@"gameOverPanel"];
    if (!gameOverPanel) {
        return;
    }
    SKSpriteNode *rightFullStar = [[SKSpriteNode alloc] initWithImageNamed:@"rightStarFull.png"];
    [rightFullStar setSize:CGSizeMake(gameOverPanel.frame.size.width * 0.16, gameOverPanel.frame.size.width * 0.16)];
    [rightFullStar setPosition:CGPointMake(+gameOverPanel.frame.size.width * 0.15, gameOverPanel.frame.size.height* 0.28)];
    [rightFullStar   setAlpha:0.0f];
    [gameOverPanel addChild:rightFullStar];
    SKAction *scaleDown = [SKAction scaleTo:0.5 duration:0.3];
    SKAction *moveDown = [SKAction moveToY:gameOverPanel.frame.size.height* 0.08 duration:0.3];
    SKAction *fadeIn = [SKAction fadeAlphaTo:1.0f duration:0.3];
    SKAction *allActions = [SKAction group:@[scaleDown,moveDown,fadeIn]];
    
    [rightFullStar runAction:allActions];
}
-(void)showBestPatternWithWinnerTrace:(SKShapeNode*)winnerTrace{
    int numberOfTiles = [(NSNumber*)winnerTrace.userData[@"numberOfTiles"] intValue];
//    int points = pow(2, numberOfTiles);
    //fonts
    SKLabelNode *bestpatternLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    SKLabelNode *bestpatternCountLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    //texts
    [bestpatternLabel setText:@"Your Best Pattern"];
    [bestpatternCountLabel setText:[NSString stringWithFormat:@"%@ Tiles",(NSNumber*)winnerTrace.userData[@"numberOfTiles"]]];
    //positions
    [bestpatternLabel setPosition:CGPointMake(CGRectGetMidX(self.frame)-self.frame.size.width*0.10,CGRectGetMidY(self.frame)-self.frame.size.height * 0.05f)];
    [bestpatternCountLabel setPosition:CGPointMake(bestpatternLabel.position.x + self.size.width * 0.10f,bestpatternLabel.position.y - bestpatternLabel.frame.size.height )];
    //sizes
    [bestpatternLabel setFontSize:[PHProperties fontSizeForGameScene]];
    [bestpatternCountLabel setFontSize:[PHProperties fontSizeForGameScene]+[PHProperties fontSizeForGameScene]* 0.5];
    
    
    [self addChild:bestpatternCountLabel];
    [self addChild:bestpatternLabel];
}

- (void)resumeToSummaryScreen{
    SummaryScene *summaryScene = [[SummaryScene alloc] initWithSize:self.size];
    [summaryScene setPoint:[scoreboardNode.scoreLabel.text floatValue]];
    SKTransition *doors = [SKTransition doorsOpenVerticalWithDuration:0.5];
    [self.view presentScene:summaryScene transition:doors];
    
}




#pragma mark - GCHelper delegate methods
- (void)matchEnded {
    NSLog(@"Match ended");
}
- (void)pointRecieved:(int)points{
    [(SKLabelNode *)[scoreboardNode childNodeWithName:@"otherScoreNode"] setText:[NSString stringWithFormat:@"%i",points]];
    
}

- (void)sendPointsToOpponent:(int)points{
    MessagePoints message;
    message.message.messageType = kMessageTypePoints;
    message.points = points;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessagePoints)];
    [self sendData:data];
}

- (void)sendData:(NSData *)data {
    NSError *error;
    BOOL success = [[GCHelper sharedInstance].match sendDataToAllPlayers:data withDataMode:GKMatchSendDataReliable error:&error];
    if (!success) {
        NSLog(@"Error sending init packet");
        [self matchEnded];
    }
}

//just number of tiles, change the method for completion and make a new method for point calc.

#pragma mark - iAd Delegate Methods

- (void)bannerViewWillLoadAd:(ADBannerView *)banner  NS_AVAILABLE_IOS(5_0){
    
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner{
    //reposition the muteNode


}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    [self hideBanner];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave{
    
    return YES;
}


- (void)bannerViewActionDidFinish:(ADBannerView *)banner{
    
}

- (void)hideBanner{
    [UIView animateWithDuration:1.0 animations:^(void){
        //set alpha to 1
        [[self getBannerView] setAlpha:0.0f];
    } completion:^(BOOL finished){
        [[self getBannerView] removeFromSuperview];
    }];
}

- (ADBannerView*)getBannerView{
    for (UIView *tempView in self.view.subviews) {
        if ([tempView isKindOfClass:[ADBannerView class]]) {
            return (ADBannerView*)tempView;
        }
    }
    return nil;
}


#pragma mark - not used methods
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
    [helloNode setFontSize:[PHProperties fontSizeForGameScene]];
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
@end
