//
//  PlanningPokerClient.h
//  iPlanningPoker
//
//  Created by Denis Arsenault on 03/11/14
//  Copyright (c) mybrightzone All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

#define kMaxAvailableServers 3

typedef enum
{
	ClientStateIdle,
	ClientStateLookingForServers,
	ClientStateConnecting,
	ClientStateConnected,
}
ClientState;

@protocol PlanningPokerClientDelegate;

@interface PlanningPokerClient : NSObject<GKSessionDelegate>

@property (strong, nonatomic) NSMutableArray *availableServers;
@property (strong, nonatomic) GKSession *session;
@property (strong, nonatomic) NSString *serverPeerId;

@property (weak, nonatomic) id<PlanningPokerClientDelegate> delegate;

- (void)startLookingForServersWithSessionId:(NSString *)sessionId andName:(NSString *)name;
- (void)connectToServerWithPeerId:(NSString *)peerId;
- (void)disconnectFromServer;
- (ClientState) getState;

@end

@protocol PlanningPokerClientDelegate <NSObject>

- (void)planningPokerClient:(PlanningPokerClient *)client serverBecameAvailable:(NSString *)peerId;
- (void)planningPokerClient:(PlanningPokerClient *)client serverBecameUnavailable:(NSString *)peerId;
- (void)planningPokerClient:(PlanningPokerClient *)client disconnectedFromServer:(NSString *)peerdId;
- (void)planningPokerClient:(PlanningPokerClient *)client withErrorReason:(ErrorReason)errorReason;
- (void)didConnectToServer;

@end
