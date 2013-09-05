//
//  PHCorridor.m
//  PatternHunt
//
//  Created by alp keser on 6/25/13.
//  Copyright (c) 2013 alp keser. All rights reserved.
//

#import "PHCorridor.h"

@implementation PHCorridor
@synthesize order,speed,myTileFactory;

- (id)initWithOrder:(int)anOrder withFrame:(CGRect)aFrame andScene:(SKScene*)aScene andRunning:(BOOL)isRunning{
    self = [super init];
//    myTileFactory = [[PHTileFactory alloc] initWithOrder:order inFrame:aFrame];
    if (isRunning) {
//        [myTileFactory allahinaFirlat:aScene];
    }else{
//        [myTileFactory birSeriFirlat:aScene];
    }
    
    return  self;
}
@end
