//
//  PHTile.m
//  PatternHunt
//
//  Created by alp keser on 6/25/13.
//  Copyright (c) 2013 alp keser. All rights reserved.
//

#import "PHTile.h"

@implementation PHTile
@synthesize isSelected,myFactory,tileType;
#pragma mark - init methods

- (id)initWithImageNamed:(NSString *)name{
    return [self initWithImageNamed:name andTileType:NORMAL];
}
//generated bolumunde
- (id)initWithImageNamed:(NSString *)name andTileType:(TileType)aTileType{
    self = [super initWithImageNamed:name];
    tileType = aTileType;
    return self;
}



@end
