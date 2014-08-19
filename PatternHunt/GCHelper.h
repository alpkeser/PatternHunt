//
//  GCHelper.h
//  PatternHunt
//
//  Created by Alp Keser on 2/18/14.
//  Copyright (c) 2014 alp keser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "NetworkHelper.h"

@protocol GCHelperDelegate
extern NSString * const kGameCenterLoggedIn;
extern NSString * const kGameCenterStartDuel;
- (void)matchEnded;
@optional
- (void)prepareMatch;
- (void)matchStarted;
- (void)match:(GKMatch *)match didReceiveData:(NSData *)data
   fromPlayer:(NSString *)playerID;
- (void)numbersRecieved;
- (void)colorCodesRecieved:(int[10][900])someColorCodes;
- (void)pointRecieved:(int)points;
@end

@interface GCHelper : NSObject <GKMatchmakerViewControllerDelegate, GKMatchDelegate,GKGameCenterControllerDelegate>{
    BOOL gameCenterAvailable;
    BOOL userAuthenticated;
    BOOL isDuelRequestSent;
    // for matchmaking
    UIViewController *presentingViewController;
    GKMatch *match;
    BOOL matchStarted;
    //baglaninca oyunculari almak icin
    NSMutableDictionary *playersDict;
    
    NSString *otherPlayerID;
    
    
}

@property (assign, readonly) BOOL gameCenterAvailable;
// for matchmaking
@property (retain) UIViewController *presentingViewController;
@property (retain) GKMatch *match;
@property (assign) id <GCHelperDelegate> delegate;
@property (retain) NSMutableDictionary *playersDict;
@property (strong,nonatomic)NetworkHelper *networkHelper;
+ (GCHelper *)sharedInstance;
- (void)authenticateLocalUser;


- (void)findMatchWithMinPlayers:(int)minPlayers maxPlayers:(int)maxPlayers
                 viewController:(UIViewController *)viewController
                       delegate:(id<GCHelperDelegate>)theDelegate;

-(void)showLeaderboardWithViewController:(UIViewController*)aVC;
@end