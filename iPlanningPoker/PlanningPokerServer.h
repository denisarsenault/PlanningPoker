//
//  PlanningPokerServer.h
//  iPlanningPoker
//
//  Created by Denis Arsenault on 03/11/14
//  Copyright (c) mybrightzone All rights reserved.
//

#import <GameKit/GameKit.h>
#import <Foundation/Foundation.h>

typedef enum
{
	ServerStateIdle,
	ServerStateAcceptingConnections,
	ServerStateStopAcceptingNewConnections,
}
ServerState;

@protocol PlanningPokerServerDelegate;

@interface PlanningPokerServer : NSObject<GKSessionDelegate>

@property (assign, nonatomic) int maxClients;
@property (strong, nonatomic) NSMutableArray *connectedClients;
@property (strong, nonatomic) GKSession *session;

@property (weak, nonatomic) id<PlanningPokerServerDelegate> delegate;

- (void)startBroadcastingForSessionId:(NSString *)sessionId;
- (void)endBroadcasting;
- (void)stopAcceptingNewConnections;

- (ServerState) getState;

@end

@protocol PlanningPokerServerDelegate <NSObject>

- (void)planningPokerServer:(PlanningPokerServer *)server connectedToClient:(NSString *)peerId;
- (void)planningPokerServer:(PlanningPokerServer *)server disconnetedFromClient:(NSString *)peerId;
- (void)planningPokerServerEndedBroadcasting:(PlanningPokerServer *)server;
- (void)planningPokerServer:(PlanningPokerServer *)server withErrorReason:(ErrorReason)errorReason;
@end
