//
//  MenuScene.h
//  PatternHunt
//
//  Created by alp keser on 6/25/13.
//  Copyright (c) 2013 alp keser. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>
#import "GCHelper.h"
#import "NetworkHelper.h"

typedef enum{
    SINGLE_PLAYER,
    MULTIPLAYER
}PlayerMode;

typedef enum{
    DEATHMATCH,
    LONGEST
}GameMode;




@interface MenuScene : SKScene<GCHelperDelegate>{
    PlayerMode playerMode;
    GameMode gameMode;
    MultiplayerType multiplayerType;

}
@property BOOL contentCreated;


- (void)setParentVC:(UIViewController*)aVC;
- (UIViewController*)parentVC;

@end
