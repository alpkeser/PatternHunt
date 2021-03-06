//
//  PHTile.m
//  PatternHunt
//
//  Created by alp keser on 6/25/13.
//  Copyright (c) 2013 alp keser. All rights reserved.
//

#import "PHTile.h"
#import "LevelManager.h"
@implementation PHTile
@synthesize isSelected,myFactory,tileType,orginalColorCode;
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

#pragma mark - coding encoding
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:myFactory forKey:@"myFactory"];
    [aCoder encodeBool:isSelected forKey:@"isSelected"];
    [aCoder encodeInt:orginalColorCode forKey:@"originalColorCode"];
    [aCoder encodeInt:(int)tileType forKey:@"tileType"];
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [self init];
    
    [self setMyFactory:[aDecoder decodeObjectForKey:@"myFactory"]];
    [self setIsSelected:[aDecoder decodeObjectForKey:@"isSelected"]];
    [self setOrginalColorCode:[aDecoder decodeIntForKey:@"originalColorCode"]];
    [self setTileType:(TileType)[aDecoder decodeIntForKey:@"tileType"]];
    
    return self;
}

//- (void)changeColor{
//    if (isSelected) {
//        [self performSelector:@selector(changeColor) withObject:nil afterDelay:1];
//    }
//    int newColorCode = orginalColorCode;
//    while (newColorCode == orginalColorCode) {
//        newColorCode = arc4random() % 3;
//    }
//    [self setTexture:[SKTexture textureWithImage:[PHProperties getImageWithNumber:newColorCode]]];
//    orginalColorCode = newColorCode;
//    [self performSelector:@selector(changeColor) withObject:nil afterDelay:1];
//}
@end
