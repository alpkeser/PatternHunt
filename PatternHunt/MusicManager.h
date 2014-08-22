//
//  MusicManager.h
//  PatternHunt
//
//  Created by Alp Keser on 8/21/14.
//  Copyright (c) 2014 alp keser. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicManager : NSObject
+(void)playMenuMusic:(id)caller;
+(void)muteMusic;
+(void)resumeMusic;
@end
