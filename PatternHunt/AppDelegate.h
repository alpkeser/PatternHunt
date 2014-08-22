//
//  AppDelegate.h
//  PatternHunt
//
//  Created by alp keser on 6/24/13.
//  Copyright (c) 2013 alp keser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic)        AVAudioPlayer *audioPlayer;

@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

-(void)playMenuMusic;
-(void)muteMusic;
-(void)resumeMusic;
@end

