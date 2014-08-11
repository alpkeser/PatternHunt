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
#import "GameScene.h"
#import <iAd/iAd.h>


@interface MenuScene : SKScene<GCHelperDelegate,ADBannerViewDelegate>{
    
    
    
}
@property BOOL contentCreated;
@property(strong,nonatomic) GameScene *gameScene;
@property (strong,nonatomic)ADBannerView *bannerView;
- (void)setParentVC:(UIViewController*)aVC;
- (UIViewController*)parentVC;
@end
