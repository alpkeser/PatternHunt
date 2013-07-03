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
@implementation GameScene
@synthesize contentCreated;
- (void)didMoveToView:(SKView *)view
{
    factories = [[NSMutableArray alloc] init];
    PHTileFactory *aFactory = [[PHTileFactory alloc] initWithOrder:1 inFrame:self.view.frame];
    [aFactory birSeriFirlat:self];
//    [aFactory allahinaFirlat:self];
    [factories addObject:aFactory];
    aFactory = [[PHTileFactory alloc] initWithOrder:2 inFrame:self.view.frame];
    [aFactory allahinaFirlat:self];
    aFactory = [[PHTileFactory alloc] initWithOrder:3 inFrame:self.view.frame];
    [aFactory allahinaFirlat:self];
    aFactory = [[PHTileFactory alloc] initWithOrder:4 inFrame:self.view.frame];
    [aFactory allahinaFirlat:self];
    aFactory = [[PHTileFactory alloc] initWithOrder:5 inFrame:self.view.frame];
    [aFactory allahinaFirlat:self];
    aFactory = [[PHTileFactory alloc] initWithOrder:6 inFrame:self.view.frame];
    [aFactory allahinaFirlat:self];
    aFactory = [[PHTileFactory alloc] initWithOrder:7 inFrame:self.view.frame];
    [aFactory allahinaFirlat:self];
//    aFactory = [[PHTileFactory alloc] initWithOrder:8 inFrame:self.view.frame];
//    [aFactory allahinaFirlat:self];
//    aFactory = [[PHTileFactory alloc] initWithOrder:9 inFrame:self.view.frame];
//    [aFactory allahinaFirlat:self];
//    aFactory = [[PHTileFactory alloc] initWithOrder:10 inFrame:self.view.frame];
//    [aFactory birSeriFirlat:self];
    
//    PHCorridor *aCorridor = [[PHCorridor alloc] initWithOrder:1 withFrame:self.view.frame andScene:self andRunning:YES];
    
}
- (void)didEvaluateActions{
    for (PHTileFactory *tileFac in factories) {
        
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    PHTileFactory *tempFac = [factories objectAtIndex:0];
//    [tempFac stopTheTiles];
}

@end
