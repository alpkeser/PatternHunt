//
//  PHTile.m
//  PatternHunt
//
//  Created by alp keser on 6/25/13.
//  Copyright (c) 2013 alp keser. All rights reserved.
//

#import "PHTile.h"

@implementation PHTile
@synthesize isSelected,myFactory;

- (void)divideToFourPiece{
    float centerX = arc4random() % (int)self.size.width;
    float centerY = arc4random() % (int)self.size.height;
    float ustBaslangic = arc4random() % (int)self.size.width;
    float altBaslangic = arc4random() % (int)self.size.width;
    float solBaslangic = arc4random() % (int)self.size.height;
    float sagBaslangic = arc4random() % (int)self.size.height;
    
}



@end
