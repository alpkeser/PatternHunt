//
//  NetworkHelper.h
//  PatternHunt
//
//  Created by Alp Keser on 3/11/14.
//  Copyright (c) 2014 alp keser. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    kGameStateWaitingForMatch = 0,
    kGameStateWaitingForRandomNumber,
    kGameStateWaitingForStart,
    kGameStateActive,
    kGameStateDone
} GameState;
typedef enum {
    kEndReasonWin,
    kEndReasonLose,
    kEndReasonDisconnect
} EndReason;

typedef enum {
    kMessageTypeRandomNumber = 0,
    kMessageTypeGameBegin,
    kMessageTypeScoreUpdate,
    kMessageTypeGameOver,
    kMessageTypeColorCodes,
    kMessageTypePoints
} MessageType;

typedef struct {
    MessageType messageType;
} Message;

typedef struct {
    Message message;
    uint32_t randomNumber;
} MessageRandomNumber;
typedef struct {
    Message message;
    int colorCodes[10][300];
} MessageColorCodes;

typedef struct {
    Message message;
    int points;
} MessagePoints;

typedef struct {
    Message message;
} MessageGameBegin;

typedef struct {
    Message message;
    float opponentScore;
} MessageMove;

typedef struct {
    Message message;
    BOOL player1Won; //always me
} MessageGameOver;

@interface NetworkHelper : NSObject{
    
}
@property(assign,nonatomic)uint32_t ourRandom;
@property(assign,nonatomic)BOOL receivedRandom;
@property(assign,nonatomic)BOOL isServer;
@property(strong,nonatomic)NSString *otherPlayerID;

@end
