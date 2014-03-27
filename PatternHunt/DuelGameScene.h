//
//  DuelGameScene.h
//  PatternHunt
//
//  Created by Alp Keser on 3/9/14.
//  Copyright (c) 2014 alp keser. All rights reserved.
//

#import "GameScene.h"
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
    kMessageTypeMove,
    kMessageTypeGameOver
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
} MessageGameBegin;

typedef struct {
    Message message;
} MessageMove;

typedef struct {
    Message message;
    BOOL player1Won; //always me
} MessageGameOver;
@interface DuelGameScene : GameScene{
    uint32_t ourRandom;
    BOOL receivedRandom;
    
}

@end
