//
//  MusicManager.m
//  PatternHunt
//
//  Created by Alp Keser on 8/21/14.
//  Copyright (c) 2014 alp keser. All rights reserved.
//

#import "MusicManager.h"
#import <AVFoundation/AVFoundation.h>
@implementation MusicManager
+(void)playMenuMusic:(id)caller{
//    /add music
    [[AVAudioSession sharedInstance] setDelegate: caller];
    NSError *setCategoryError = nil;
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: &setCategoryError];
    [[AVAudioSession sharedInstance] setActive: YES error: &setCategoryError];
    
    if (setCategoryError)
        NSLog(@"Error setting category! %@", setCategoryError);
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"menu" ofType:@"m4a"];
    AVAudioPlayer *audioPlayer;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:NULL];
    [audioPlayer setNumberOfLoops:-1];
    [audioPlayer prepareToPlay];
    [audioPlayer play];
}

+(void)muteMusic{
    
}
+(void)resumeMusic{
    
}
@end
