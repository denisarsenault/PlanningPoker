//
//  PlanningPoker.h
//  iPlanningPoker
//
//  Created by Denis Arsenault
//  Copyright (c) mybrightzone All rights reserved.
//

#import "DataPacket.h"

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

typedef enum {
    
    PlanningPokerCardsWaitingForSignIn,
    PlanningPokerCardsWaitingForReady,
    PlanningPokerCardsChooseCardValue,
    PlanningPokerCardsWaitingForNextRound,
    PlanningPokerCardsStopping
    
} PlanningPokerCardsState;

@protocol PlanningPokerCardsDelegate;

@interface PlanningPokerCards : NSObject<GKSessionDelegate>

@property (weak, nonatomic) id<PlanningPokerCardsDelegate> delegate;
@property (strong, nonatomic) GKSession *session;
@property (strong, nonatomic) NSString *serverPeerId;

- (void)joinPlanningWithSession:(GKSession *)session;
- (void)leavePlanningWithReason:(ErrorReason)errorReason;
- (void)receivedDataPacket:(DataPacket *)dataPacket;
- (void)sendCardValueToServer:(NSString *) cardValue;
- (void)sendDataPacketToServer:(DataPacket *)dataPacket;
- (void)beginPlanningSession;

- (PlanningPokerCardsState)getState;

@end

@protocol PlanningPokerCardsDelegate <NSObject>

- (void)leavePlanning:(PlanningPokerCards *)cards withReason:(ErrorReason)errorReason;
- (void)disableUI;
- (void)enableUI;
- (void)connectionEstablished;

@end

