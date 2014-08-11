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
#pragma mark - SKScene event methods
- (void)didMoveToView:(SKView *)view
{
    [self setIsFinished:NO];
    [self setIsPaused:NO];
    [LevelManager initLevels];
    self.traces = [NSMutableArray new];
    dispatch_after( dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        //code to be executed on the main queue after delay
        [self increasePressure];
    });
    

    secondsLeft = 60.0;
//    [self setBackgroundColor:[UIColor colorWithRed:247.0f/255.0f green:175.0f/255.0f blue:29.0f/2555.0f alpha:1]];
    [self setBackgroundColor:[UIColor blackColor]];
//    SKSpriteNode *bgNode = [[SKSpriteNode alloc] initWithImageNamed:@"bg.png"];
//    SKShapeNode *shapeBgNode = [[SKShapeNode ]
//    [bgNode setSize:self.size];
//    [bgNode setPosition:CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame))];
//    [self addChild:bgNode];   
    isSceneStopped = NO;
    doesGameStarted = NO;
    if (_factories == nil) {
        _factories = [self setupFactoriesWithFrame:self.view.frame];
    }
   
    
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
            [self processTouchWithX:pos.x andAY:pos.y]; //-aalpk
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

#pragma mark - touch delegates
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (!doesGameStarted || self.isFinished) {
        return;
    }
    if ( [[(SKNode*)[self nodeAtPoint:[(UITouch*)[touches anyObject] locationInNode:self]] name] isEqualToString:@"pauseButtonNode"] ) {
        if (self.gameType == SINGLE) {
            [self setIsPaused:YES];
            [self stopScene];
            [self showPauseMenu];
        }
        
    }
    [self traceBeginFromPoint:[[touches allObjects] objectAtIndex:0]];
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
    if (!doesGameStarted || self.isFinished) {
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
    
    if (!doesGameStarted || self.isFinished) {
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
    //[aTile setColor:[UIColor whiteColor]];
    //aalpk
    [aTile setTexture:[SKTexture textureWithImageNamed:@"blackTile.png"]];
//    aTile runAction:
//    [aTile runAction:[SKAction repeatActionForever:[SKAction sequence:@[[SKAction moveBy:CGVectorMake(+1, 0) duration:0.3]]]]];
//    [aTile setFillColor:[UIColor blackColor]];
    [aTile setIsSelected:YES];
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

    if (!isSceneStopped) {
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

- (void) showPauseMenu{
    SKSpriteNode *menuBackgroundNode = [[SKSpriteNode alloc] initWithImageNamed:@"orange_tile.png"];
    [menuBackgroundNode  setSize:CGSizeMake(self.frame.size.width * 0.8, self.frame.size.width * 0.4)];
    [menuBackgroundNode setPosition:CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.7 )];
    [self addChild:menuBackgroundNode];
    
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
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),^(void){
        while (self.traces.count !=0) {
            
        }
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self showBestPatternWithWinnerTrace:winnerTrace];
        });
    });
    float timeUnit = 3.0f  / self.traces.count;
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

-(void)showBestPatternWithWinnerTrace:(SKShapeNode*)winnerTrace{
    //fonts
    SKLabelNode *bestpatternLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    SKLabelNode *bestpatternCountLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    //texts
    [bestpatternLabel setText:@"Your Best Pattern"];
    [bestpatternCountLabel setText:[NSString stringWithFormat:@"%@ Tiles",(NSNumber*)winnerTrace.userData[@"numberOfTiles"]]];
    //positions
    [bestpatternLabel setPosition:CGPointMake(CGRectGetMidX(self.frame)-self.frame.size.width*0.10,CGRectGetMidY(self.frame)-self.frame.size.height * 0.05f)];
    [bestpatternCountLabel setPosition:CGPointMake(bestpatternLabel.position.x + bestpatternLabel.frame.size.width * 0.75,bestpatternLabel.position.y - bestpatternLabel.frame.size.height )];
    //sizes
    [bestpatternLabel setFontSize:[PHProperties fontSizeForGameScene]];
    [bestpatternCountLabel setFontSize:[PHProperties fontSizeForGameScene]+[PHProperties fontSizeForGameScene]* 0.5];
    
    
    [self addChild:bestpatternCountLabel];
    [self addChild:bestpatternLabel];
}

- (void)resumeToSummaryScreen{
    SummaryScene *gameScene = [[SummaryScene alloc] initWithSize:self.size];
    [gameScene setPoint:[scoreboardNode.scoreLabel.text floatValue]];
    SKTransition *doors = [SKTransition doorsOpenVerticalWithDuration:0.5];
    [self.view presentScene:gameScene transition:doors];
    
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

- (void)updateCounter{
    if (self.isPaused) {
        return;
    }
    secondsLeft = secondsLeft - 0.1f ;
    if (secondsLeft < 0.0f) {
        [timer invalidate];
        [self endGame];
        return;
    }
    SKLabelNode *timeNode = (SKLabelNode*)[scoreboardNode childNodeWithName:@"timeNode"];
    [timeNode setText:[NSString stringWithFormat:@"%.01f seconds",secondsLeft]];
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
@end
