//
//  MenuScene.m
//  PatternHunt
//
//  Created by alp keser on 6/25/13.
//  Copyright (c) 2013 alp keser. All rights reserved.
//

#import "MenuScene.h"
#import "AppDelegate.h"
#import "PHTileFactory.h"
#define kSingleButtonYPosition 0.65
#define kDuelButtonYPosition 0.55
#define kLeaderboardsButtonYPosition 0.45
@implementation MenuScene
UIViewController const *parentVC;
@synthesize contentCreated;

- (void)didMoveToView:(SKView *)view{
    //add banner
    [self setBannerView:[self getBannerView]];
    if (!self.bannerView) {
    self.bannerView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
        [self.bannerView setFrame:CGRectMake(0, self.view.frame.size.height - self.bannerView.frame.size.height, 0,0)];
    [self.view addSubview:self.bannerView];
    [self.bannerView setAlpha:0.0f];
    
    }
    [self.bannerView setDelegate:self];
    if (!self.contentCreated) {
        [self createSceneContents];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(findMatch)
                                                 name:kGameCenterLoggedIn
                                               object:nil];
 
    

}
- (void)createSceneContents{
    SKSpriteNode *bgNode = [[SKSpriteNode alloc] initWithImageNamed:@"background.png"];
    [bgNode setSize:self.size];
    [bgNode setPosition:CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame))];
    [self addChild:bgNode];
    [self setScaleMode:SKSceneScaleModeAspectFit];
    [self addChild:[self singleNode]];
    [self addChild:[self duelNode]];
    [self addChild:[self leaderboardNode]];
    [self addChild:[self muteNode]];
    [self addChild:[self questNode]];
    [self addLogo];
//    for (int sayac = 0; sayac<200; sayac++) {
//        [self testShapeNode];
//    }
////    [self testShapeNode];
    
    
}

- (SKSpriteNode*)singleNode{
    /*
    SKLabelNode *singleNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    [singleNode setText:@"Single"];
    [singleNode setFontSize:22];
    [singleNode setPosition:CGPointMake(CGRectGetMidX(self.frame),self.frame.size.height * kSingleButtonYPosition)];
    [singleNode setName:@"singleNode"];
     */
    //ratio is 3.182
    SKSpriteNode*singleNode = [[SKSpriteNode alloc] initWithImageNamed:@"singleButton.png"];
    [singleNode setSize:CGSizeMake(self.size.width*0.30, self.size.width*0.30/3.182)];
    [singleNode setPosition:CGPointMake(CGRectGetMidX(self.frame),self.frame.size.height * kSingleButtonYPosition)];
    [singleNode setName:@"singleNode"];
    return singleNode;
}

//Duel playing via gamecenter
- (SKSpriteNode*)duelNode{
    SKSpriteNode *duelNode = [[SKSpriteNode alloc] initWithImageNamed:@"multiplayerButton.png"];
    [duelNode setSize:CGSizeMake(self.size.width *0.30,self.size.width*0.30/3.182)];
    [duelNode setPosition:CGPointMake(CGRectGetMidX(self.frame),self.frame.size.height * kDuelButtonYPosition)];
    [duelNode setName:@"duelNode"];
    return duelNode;
}

//Leaderboards button
- (SKSpriteNode*)leaderboardNode{
    SKSpriteNode *leaderboardNode = [[SKSpriteNode alloc] initWithImageNamed:@"leaderboardButton.png"];
    [leaderboardNode setSize:CGSizeMake(self.size.width * 0.30, self.size.width * 0.30 /3.182)];
    [leaderboardNode setPosition:CGPointMake(CGRectGetMidX(self.frame),self.frame.size.height * kLeaderboardsButtonYPosition)];
    [leaderboardNode setName:@"leaderboardNode"];
    return leaderboardNode;
}

- (SKSpriteNode*)muteNode{
    SKSpriteNode* muteNode = [[SKSpriteNode alloc] initWithImageNamed:@"muteOnButton.png"];
    [muteNode setSize:CGSizeMake(self.frame.size.width * 0.10, self.frame.size.width * 0.10)];
    if (self.bannerView.alpha >0) {
    [muteNode setPosition:CGPointMake(self.frame.size.width * 0.9, self.frame.size.height *  0.05 + +  self.bannerView.frame.size.height)];
    }else{
    [muteNode setPosition:CGPointMake(self.frame.size.width * 0.9, self.frame.size.height *  0.05)];
    }

    [muteNode setName:@"muteNode"];
    return muteNode;
    
}

- (SKSpriteNode*)questNode{
    SKSpriteNode *questNode = [[SKSpriteNode alloc] initWithImageNamed:@"quest.png"];
    [questNode setSize:CGSizeMake(self.frame.size.width * 0.10, self.frame.size.width * 0.10)];
    if (self.bannerView.alpha >0) {
        [questNode setPosition:CGPointMake(self.frame.size.width * 0.1, self.frame.size.height *  0.05 + +  self.bannerView.frame.size.height)];
    }else{
        [questNode setPosition:CGPointMake(self.frame.size.width * 0.1, self.frame.size.height *  0.05)];
    }
    [questNode setName:@"questNode"];
    return questNode;
}

- (void)addLogo{
    //ratio is 4.232
    SKSpriteNode *logoNode= [[SKSpriteNode alloc] initWithImageNamed:@"headerLogo.png"];
    [logoNode setSize:CGSizeMake(self.size.height * 0.50, self.size.height * 0.50 / 4.232)];
    [logoNode setPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+self.size.height * 0.30)];
    [self addChild:logoNode];
}

#pragma mark - Touch Methods
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    SKNode *helloNode = [self nodeAtPoint:[(UITouch*)[touches anyObject] locationInNode:self]] ;
    if(helloNode == nil)
        return;
    if ([[helloNode name] isEqualToString:@"muteNode"]) {
        [self mutePressed];
        return;
    }
    if ([[helloNode name] isEqualToString:@"singleNode"]) {
        _gameScene = [[GameScene alloc] initWithSize:self.size];
        [_gameScene setGameType:SINGLE];
        [_gameScene setFactories:[_gameScene setupFactoriesWithFrame:self.view.frame]];
        [self startGame:helloNode];
//        [self showGameModePanel];
        return;
    }
    UIAlertView *alert;
    if ([[helloNode name] isEqualToString:@"duelNode"]) {
        if ([[GKLocalPlayer localPlayer] isAuthenticated]) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startDuel) name:kGameCenterStartDuel object:nil];
            _gameScene = [[GameScene alloc] initWithSize:self.size];
            [_gameScene setGameType:MULTIPLAYER];
            [[[GCHelper sharedInstance] networkHelper] setOurRandom:arc4random()];
            [self findMatch];
            
            
        }else{
            alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Wait a second to connect to gamecenter.. Then try again!!" delegate:nil cancelButtonTitle:@"Allright" otherButtonTitles: nil];
            [alert show];
        }


        return;
    }
    
    if ([[helloNode name] isEqualToString:@"leaderboardNode"]) {
        [self showLeaderboard];
        return;
    }

    
}
#pragma mark - action methods
-(void)showLeaderboard{
    GCHelper *helper = [GCHelper sharedInstance];
    [helper showLeaderboardWithViewController:self.parentVC];
}

- (void)mutePressed{
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] muteMusic];
}
- (void)showGameModePanel{
    SKSpriteNode *panel = [[SKSpriteNode alloc] initWithColor:[UIColor redColor] size:CGSizeMake(200, 200)];
    [panel setPosition:CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame))];
    [panel setName:@"panel"];
    [self addChild:panel];
    
    //adding deathmatch
    //
    SKLabelNode *deathmatchButtonNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    [deathmatchButtonNode setText:@"Deathmatch"];
    [deathmatchButtonNode setFontSize:22];
    [deathmatchButtonNode setPosition:CGPointMake(deathmatchButtonNode.position.x, panel.size.height * 0.10)];
    [deathmatchButtonNode setName:@"deathmatchNode"];
    [panel addChild:deathmatchButtonNode];
    
    //adding longest
    //
    SKLabelNode *longestButtonNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    [longestButtonNode setText:@"Longest"];
    [longestButtonNode setFontSize:22];
    [longestButtonNode setPosition:CGPointMake(deathmatchButtonNode.position.x, -panel.size.height * 0.10)];
    [longestButtonNode setName:@"longestmatchNode"];
    [panel addChild:longestButtonNode];
    
}

- (void)findMatch{
    //    AppDelegate * delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    [[GCHelper sharedInstance] findMatchWithMinPlayers:2 maxPlayers:2 viewController:self.parentVC delegate:self];
}


- (void)startGame:(SKNode*)aNode{
    SKAction *moveup = [SKAction moveByX:0 y:20 duration:0.3];
    SKAction *zoom = [SKAction scaleTo:1.3 duration:0.1];
    SKAction *pause = [SKAction waitForDuration:0.3];
    SKAction *fadeAway = [SKAction fadeInWithDuration:0.25];
    SKAction *remove = [SKAction removeFromParent];
    SKAction *seq = [SKAction sequence:@[moveup,zoom,pause,fadeAway,remove]];
//    [self hideBanner];
    [aNode runAction:seq completion:^{
        SKTransition *doors = [SKTransition doorsOpenVerticalWithDuration:0.5];
        [self.view presentScene:_gameScene transition:doors];
    }];
}
- (void)startDuel{

    
    [self startGame:(SKNode*)[self children ].lastObject];
    
}


#pragma mark - network methods
- (void)sendData:(NSData *)data {
    NSError *error;
    BOOL success = [[GCHelper sharedInstance].match sendDataToAllPlayers:data withDataMode:GKMatchSendDataReliable error:&error];
    if (!success) {
        NSLog(@"Error sending init packet");
        [self matchEnded];
    }
}

- (void)sendRandomNumber {
    
    MessageRandomNumber message;
    message.message.messageType = kMessageTypeRandomNumber;
    message.randomNumber = [[[GCHelper sharedInstance] networkHelper] ourRandom];
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageRandomNumber)];
    [self sendData:data];
}

- (void)numbersRecieved{
    if ([[[GCHelper sharedInstance] networkHelper] isServer]) {
        //generate tiles and send
        assert(_gameScene != nil);
        NSMutableArray *serverFactories = [_gameScene setupFactoriesWithFrame:self.view.frame];
        [self sendFactories:serverFactories];
        [_gameScene setFactories:serverFactories];
        
    }
    //add preparing match scene
}


- (void)sendFactories:(NSMutableArray*)someFactories{
    
    MessageColorCodes message;
    message.message.messageType = kMessageTypeColorCodes;
   [self colorArray:message.colorCodes fromFactories:someFactories];

    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageColorCodes)];
    [self sendData:data];
        [self startGame:[self childNodeWithName:@"duelNode"]];
}

- (void)factoriesRecieved:(NSMutableArray*)someFactories{
    [_gameScene setFactories:someFactories];
    [self startGame:[self childNodeWithName:@"duelNode"]];
}
- (void)colorCodesRecieved:(int[10][900])someColorCodes{
    [_gameScene setFactoriesFromColorCodes:someColorCodes andWithFrame:self.view.frame];
        [self startGame:[self childNodeWithName:@"duelNode"]];
}

#pragma mark GCHelperDelegate

- (void)prepareMatch{
    //ids exchanged
    [self sendRandomNumber];
}

- (void)matchStarted {
    NSLog(@"Match started");
    
    //
}

- (void)matchEnded {
    NSLog(@"Match ended");
}

- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID {
    NSLog(@"Received data");
    
}



- (void)testShapeNode{
    
    //// Color Declarations
    UIColor* fillColor = [UIColor colorWithRed: 0.114 green: 0.705 blue: 1 alpha: 1];
    UIColor* strokeColor = [UIColor colorWithRed: 0 green: 0.295 blue: 0.886 alpha: 1];
    
    //// Rounded Rectangle Drawing
    UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(48.5, 14.5, 70, 70) cornerRadius: 21];


    CGFloat roundedRectanglePattern[] = {1, 1, 1, 1};
    [roundedRectanglePath setLineDash: roundedRectanglePattern count: 4 phase: 0];

    
    CGPathRef cgPath = CGPathCreateCopy(roundedRectanglePath.CGPath);

    SKShapeNode *aNode = [[SKShapeNode alloc] init];
    [aNode setPath:cgPath];
    [aNode setFillColor:fillColor];
    [aNode setStrokeColor:fillColor];
    [aNode setLineWidth:1.0f];
    [aNode setGlowWidth:1.0f];
    [aNode setAntialiased:YES];
    [aNode setBlendMode:SKBlendModeAlpha];
    [self addChild:aNode];
    
    
                    
}

- (UIViewController*)parentVC{
    return parentVC;
}

- (void)setParentVC:(UIViewController*)aVC{
    parentVC = aVC;
}

- (void)colorArray:(int[10][900])aColorArray fromFactories:(NSMutableArray*)someFactories{
    for (int sayac1 = 0; sayac1<10; sayac1++) {
        for (int sayac2 = 0; sayac2<900; sayac2++) {
            aColorArray[sayac1][sayac2]= [(NSNumber*)[[(PHTileFactory*)[someFactories objectAtIndex:sayac1] tilePattern] objectAtIndex:sayac2] intValue];
        }
    }
}

#pragma mark - iAd Delegate Methods
/*!
 * @method bannerViewWillLoadAd:
 *
 * @discussion
 * Called when a banner has confirmation that an ad will be presented, but
 * before the resources necessary for presentation have loaded.
 */
- (void)bannerViewWillLoadAd:(ADBannerView *)banner  NS_AVAILABLE_IOS(5_0){
    
}

/*!
 * @method bannerViewDidLoadAd:
 *
 * @discussion
 * Called each time a banner loads a new ad. Once a banner has loaded an ad, it
 * will display it until another ad is available.
 *
 * It's generally recommended to show the banner view when this method is called,
 * and hide it again when bannerView:didFailToReceiveAdWithError: is called.
 */
- (void)bannerViewDidLoadAd:(ADBannerView *)banner{
    //reposition the muteNode
    SKSpriteNode *muteNode = (SKSpriteNode*)[self childNodeWithName:@"muteNode"];
    [muteNode runAction:[SKAction moveTo:CGPointMake(muteNode.position.x, muteNode.position.y +  self.bannerView.frame.size.height) duration:0.8f]];
    [UIView animateWithDuration:1.0 animations:^(void){
       //set alpha to 1
        [self.bannerView setAlpha:1.0f];
    }];
}

/*!
 * @method bannerView:didFailToReceiveAdWithError:
 *
 * @discussion
 * Called when an error has occurred while attempting to get ad content. If the
 * banner is being displayed when an error occurs, it should be hidden
 * to prevent display of a banner view with no ad content.
 *
 * @see ADError for a list of possible error codes.
 */
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    [self hideBanner];
}

/*!
 * @method bannerViewActionShouldBegin:willLeaveApplication:
 *
 * Called when the user taps on the banner and some action is to be taken.
 * Actions either display full screen content modally, or take the user to a
 * different application.
 *
 * The delegate may return NO to block the action from taking place, but this
 * should be avoided if possible because most ads pay significantly more when
 * the action takes place and, over the longer term, repeatedly blocking actions
 * will decrease the ad inventory available to the application.
 *
 * Applications should reduce their own activity while the advertisement's action
 * executes.
 */
- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave{
    
    return YES;
}

/*!
 * @method bannerViewActionDidFinish:
 *
 * Called when a modal action has completed and control is returned to the
 * application. Games, media playback, and other activities that were paused in
 * bannerViewActionShouldBegin:willLeaveApplication: should resume at this point.
 */
- (void)bannerViewActionDidFinish:(ADBannerView *)banner{
    
}

- (void)hideBanner{
    [UIView animateWithDuration:1.0 animations:^(void){
        //set alpha to 1
        [self.bannerView setAlpha:0.0f];
    } completion:^(BOOL finished){
        [self.bannerView removeFromSuperview];
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
@end
