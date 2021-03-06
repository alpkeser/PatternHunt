//
//  GCHelper.m
//  PatternHunt
//
//  Created by Alp Keser on 2/18/14.
//  Copyright (c) 2014 alp keser. All rights reserved.
//

#import "GCHelper.h"
#import "User.h"


@implementation GCHelper
@synthesize presentingViewController;
@synthesize match;
@synthesize delegate;
@synthesize playersDict;
static GCHelper *sharedHelper = nil;
NSString * const kGameCenterLoggedIn = @"kGameCenterLoggedIn";
NSString * const kGameCenterStartDuel = @"kStartDuel";
+ (GCHelper *) sharedInstance {
    if (!sharedHelper) {
        sharedHelper = [[GCHelper alloc] init];
    }
    return sharedHelper;
}

- (BOOL)isGameCenterAvailable {
    // check for presence of GKLocalPlayer API
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    
    // check if the device is running iOS 4.1 or later
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer
                                           options:NSNumericSearch] != NSOrderedAscending);
    
    return (gcClass && osVersionSupported);
}

- (id)init {
    if ((self = [super init])) {
        gameCenterAvailable = [self isGameCenterAvailable];
        isDuelRequestSent = NO;
        _networkHelper = [NetworkHelper new];
        if (gameCenterAvailable) {
            NSNotificationCenter *nc =
            [NSNotificationCenter defaultCenter];
            [nc addObserver:self
                   selector:@selector(authenticationChanged)
                       name:GKPlayerAuthenticationDidChangeNotificationName
                     object:nil];
        }
    }
    return self;
}

- (void)authenticationChanged {
    
    if ([
         GKLocalPlayer localPlayer].isAuthenticated && !userAuthenticated) {
        NSLog(@"Authentication changed: player authenticated.");
        //[[NSNotificationCenter defaultCenter] postNotificationName:kGameCenterLoggedIn object:nil];
        userAuthenticated = TRUE;
    } else if (![GKLocalPlayer localPlayer].isAuthenticated && userAuthenticated) {
        NSLog(@"Authentication changed: player not authenticated");
        userAuthenticated = FALSE;
    }
    
}

#pragma mark User functions

- (void)authenticateLocalUser {
    
    if (!gameCenterAvailable) return;
    
    NSLog(@"Authenticating local user...");
    if ([User isAuthenticated] == NO) {
        [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:nil];
    } else {
        NSLog(@"Already authenticated!");
        
    }
}


// Add new method, right after authenticateLocalUser
- (void)findMatchWithMinPlayers:(int)minPlayers maxPlayers:(int)maxPlayers
                 viewController:(UIViewController *)viewController
                       delegate:(id<GCHelperDelegate>)theDelegate {
    
    if (!gameCenterAvailable) return;
    if (isDuelRequestSent) {
        return;
    }
    isDuelRequestSent = YES;
    matchStarted = NO;
    self.match = nil;
    self.presentingViewController = viewController;
    delegate = theDelegate;
//    [presentingViewController dismissModalViewControllerAnimated:NO];
    
    GKMatchRequest *request = [[GKMatchRequest alloc] init] ;
    request.minPlayers = minPlayers;
    request.maxPlayers = maxPlayers;
    
        GKMatchmakerViewController *mmvc =
        [[GKMatchmakerViewController alloc] initWithMatchRequest:request];
        mmvc.matchmakerDelegate = self;
    
        [presentingViewController presentModalViewController:mmvc animated:YES];
    
//    [[GKMatchmaker sharedMatchmaker] findMatchForRequest:request withCompletionHandler:^(GKMatch *match, NSError *error) {
//        isDuelRequestSent = NO;
//        if (error)
//        {
//            // Process the error.
//        }
//        else if (match != nil)
//        {
//             // Use a retaining property to retain the match.
//            match.delegate = self;
//            self.match = match;
//            if (!matchStarted && match.expectedPlayerCount == 0)
//            {
//                matchStarted = YES;
//                // Insert application-specific code to begin the match.
//                //decide who is server if client wait for the tile if server generate and send then wait client ok response then go
//                NSLog(@"go aalpk");
//                
//            }
//        }
//    }];
//    
    
}
//- (IBAction)findProgrammaticMatch: (id) sender
//{
//    GKMatchRequest *request = [[[GKMatchRequest alloc] init] autorelease];
//    request.minPlayers = 2;
//    request.maxPlayers = 4;
//
//    [[GKMatchmaker sharedMatchmaker] findMatchForRequest:request withCompletionHandler:^(GKMatch *match, NSError *error) {
//        if (error)
//        {
//            // Process the error.
//        }
//        else if (match != nil)
//        {
//            self.myMatch = match; // Use a retaining property to retain the match.
//            match.delegate = self;
//            if (!self.matchStarted && match.expectedPlayerCount == 0)
//            {
//                self.matchStarted = YES;
//                // Insert application-specific code to begin the match.
//            }
//        }
//    }];
//}

-(void)showLeaderboardWithViewController:(UIViewController*)aVC{
    // tutorial: http://www.appcoda.com/ios-game-kit-framework/
    GKGameCenterViewController *gcViewController = [[GKGameCenterViewController alloc] init];
    
    gcViewController.gameCenterDelegate = self;
    
    //    if (shouldShowLeaderboard) {
    gcViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
    gcViewController.leaderboardIdentifier = @"high_score_in_single";
    //    }
    //    else{
    //        gcViewController.viewState = GKGameCenterViewControllerStateAchievements;
    //    }
    
    [aVC presentViewController:gcViewController animated:YES completion:nil];
}

-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark GKMatchmakerViewControllerDelegate

// The user has cancelled matchmaking
- (void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)viewController {
#if DEBUG 
    NSLog(@"matchMaker canceled");
#endif
        isDuelRequestSent = NO;
    [presentingViewController dismissModalViewControllerAnimated:YES];
}

// Matchmaking has failed with an error
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError *)error {
#if DEBUG
    NSLog(@"matchMaker fail w error");
    NSLog(@"Error finding match: %@", error.localizedDescription);
#endif
    [presentingViewController dismissModalViewControllerAnimated:YES];
        isDuelRequestSent = NO;
    
}

// A peer-to-peer match has been found, the game should start
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFindMatch:(GKMatch *)theMatch {
        isDuelRequestSent = NO;
    [presentingViewController dismissModalViewControllerAnimated:YES];
    self.match = theMatch;
    match.delegate = self;
    if (!matchStarted && match.expectedPlayerCount == 0) {
        NSLog(@"Ready to start match!");
        [self lookupPlayers];
        //   [[NSNotificationCenter defaultCenter] postNotificationName:kGameCenterStartDuel object:nil];
    }
}


#pragma mark GKMatchDelegate

// The match received data sent from the player.
- (void)match:(GKMatch *)theMatch didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID {
#if DEBUG
    NSLog(@"recievedData");
#endif
    
    if (match != theMatch) return;
    
    // Store away other player ID for later
    if (otherPlayerID == nil) {
        otherPlayerID = playerID;
    }
    Message *message = (Message *) [data bytes];
    
    //decide server / client
    if (message->messageType == kMessageTypeRandomNumber) {
        
        MessageRandomNumber * messageInit = (MessageRandomNumber *) [data bytes];
        if ([_networkHelper ourRandom]>messageInit->randomNumber) {
            [_networkHelper setIsServer:YES];
        }else{
#if DEBUG
            NSLog(@"isserverno");
#endif
            [_networkHelper setIsServer:NO];
        }
        [delegate numbersRecieved];
        NSLog(@"%i",messageInit->randomNumber);
        return;
    }
    
    //getfactories appearantly
    if (message->messageType == kMessageTypeColorCodes) {
        
        MessageColorCodes * messageColorCodes = (MessageColorCodes *) [data bytes];
        
        [delegate colorCodesRecieved:messageColorCodes->colorCodes];

    }
    //points recieved
    if (message->messageType == kMessageTypePoints) {
        
        MessagePoints * messagePoints = (MessagePoints *) [data bytes];
        
        [delegate pointRecieved:messagePoints->points];
        
    }
}

// The player state changed (eg. connected or disconnected)
- (void)match:(GKMatch *)theMatch player:(NSString *)playerID didChangeState:(GKPlayerConnectionState)state {
    if (match != theMatch) return;
    
    switch (state) {
        case GKPlayerStateConnected:
            // handle a new player connection.
            NSLog(@"Player connected!");
            
            if (!matchStarted && theMatch.expectedPlayerCount == 0) {
                NSLog(@"Ready to start match!");
                //should send a notfification to start game
                [self lookupPlayers];
                //    [delegate match:theMatch didReceiveData:data fromPlayer:playerID];
            }
            
            break;
        case GKPlayerStateDisconnected:
            // a player just disconnected.
            NSLog(@"Player disconnected!");
            matchStarted = NO;
            [delegate matchEnded];
            break;
    }
}

// The match was unable to connect with the player due to an error.
- (void)match:(GKMatch *)theMatch connectionWithPlayerFailed:(NSString *)playerID withError:(NSError *)error {
    
    if (match != theMatch) return;
    
    NSLog(@"Failed to connect to player with error: %@", error.localizedDescription);
    matchStarted = NO;
    [delegate matchEnded];
}

// The match was unable to be established with any players due to an error.
- (void)match:(GKMatch *)theMatch didFailWithError:(NSError *)error {
    
    if (match != theMatch) return;
    
    NSLog(@"Match failed with error: %@", error.localizedDescription);
    matchStarted = NO;
    [delegate matchEnded];
}





- (void)lookupPlayers {
    
    NSLog(@"Looking up %d players...", match.playerIDs.count);
    [GKPlayer loadPlayersForIdentifiers:match.playerIDs withCompletionHandler:^(NSArray *players, NSError *error) {
        
        if (error != nil) {
            NSLog(@"Error retrieving player info: %@", error.localizedDescription);
            matchStarted = NO;
            [delegate matchEnded];
        } else {
            
            // Populate players dict
            self.playersDict = [NSMutableDictionary dictionaryWithCapacity:players.count];
            for (GKPlayer *player in players) {
                NSLog(@"Found player: %@", player.alias);
                [playersDict setObject:player forKey:player.playerID];
            }
            
            // Notify delegate match can begin
            matchStarted = YES;
            [delegate prepareMatch];
            //            [delegate matchStarted];
            
        }
    }];
    
}

- (void)decideServerWithResponseRandom:(uint32_t)number{
    [_networkHelper setReceivedRandom:YES];
    if ([ _networkHelper ourRandom] > number) {
        [_networkHelper setIsServer:YES];
    }
    
}



@end
