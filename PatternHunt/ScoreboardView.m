//
//  ScoreboardView.m
//  PatternHunt
//
//  Created by Alp Keser on 7/16/13.
//  Copyright (c) 2013 alp keser. All rights reserved.
//

#import "ScoreboardView.h"
#define DegreesToRadians(x) ((x) * M_PI / 180.0)
@implementation ScoreboardView
@synthesize okView,scoreLabel;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self kadranKoy:frame];
        [self addScoreBoard:frame];
        [self addScore:frame];
        [UIView beginAnimations:@"rotate" context:nil];
        [UIView setAnimationDuration:5];
        okView.transform = CGAffineTransformMakeRotation(DegreesToRadians(170));
       [UIView commitAnimations];
    }
    return self;
}


- (void)kadranKoy:(CGRect)frame{
    UIImageView *kadranView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.height, frame.size.height)];
    [kadranView setImage:[UIImage imageNamed:@"bos_kadran.png"]];
    okView = [[UIImageView alloc] initWithFrame:CGRectMake(kadranView.frame.size.width * 0.4, kadranView.frame.size.height * 0.4, kadranView.frame.size.height *0.3, kadranView.frame.size.height*0.3)];
    [okView setImage:[UIImage imageNamed:@"meter_Icon.png"]];
    [[okView layer] setAnchorPoint:CGPointMake(1, 1)];
    [kadranView addSubview:okView];
    [self addSubview:kadranView];
    
}

- (void)addScoreBoard:(CGRect)aFrame{
    UILabel *scoreText = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width *0.70, 0, self.frame.size.width *0.15,aFrame.size.height )];
    [scoreText setText:@"Score"];
    [scoreText setFont:[UIFont fontWithName:@"Helvetica" size:22.0f]];
    [self addSubview:scoreText];
}
- (void)addScore:(CGRect)aFrame{
    scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width *0.85, 0, self.frame.size.width *0.15,aFrame.size.height )];
    [scoreLabel setFont:[UIFont fontWithName:@"Helvetica" size:22.0f]];
    [scoreLabel setText:@"00000"];
    [self addSubview:scoreLabel];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
