//
//  PlanningPokerServer.m
//  iPlanningPoker
//
//  Created by Denis Arsenault on 03/11/14
//  Copyright (c) mybrightzone All rights reserved.
//

#import "PlanningPokerServer.h"

@implementation PlanningPokerServer

ServerState serverState;

- (id)init {
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    serverState = ServerStateIdle;
    
    return self;
}

- (void)startBroadcastingForSessionId:(NSString *)sessionId {
    
    NSAssert(serverState == ServerStateIdle, @"Wrong state!!");
    
    serverState = ServerStateAcceptingConnections;
    
    self.connectedClients = [NSMutableArray arrayWithCapacity:self.maxClients];
    
    self.session = [[GKSession alloc] initWithSessionID:sessionId displayName:nil sessionMode:GKSessionModeServer];
    self.session.delegate = self;
    self.session.available = YES;
}

- (void)endBroadcasting {
    
    NSAssert(serverState != ServerStateIdle, @"Wrong state!!");
    
    serverState = ServerStateIdle;
    
    [self.session disconnectFromAllPeers];
    self.session.available = FALSE;
    self.session.delegate = nil;
    
    self.session = nil;
    
    self.connectedClients = nil;
    
    [self.delegate planningPokerServerEndedBroadcasting:self];
}

- (void)stopAcceptingNewConnections {
    NSAssert(serverState == ServerStateAcceptingConnections, @"Wrong state!!");
    
    serverState = ServerStateStopAcceptingNewConnections;
    self.session.available = FALSE;
}

#pragma mark - GKSessionDelegate
- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state {
    NSLog(@"PlanningPokerServer: peer %@ changed state %d", peerID, state);
    
    //check the state
    switch(state) {
        case GKPeerStateAvailable:
            NSLog(@"GKPeerStateAvailable");
            break;
        case GKPeerStateUnavailable:
            NSLog(@"GKPeerStateUnavailable");
            break;
        case GKPeerStateConnected:
            //Client has connected to server
            NSLog(@"GKPeerStateConnected");
            
            NSAssert(serverState == ServerStateAcceptingConnections, @"Wrong state!!");
            
            if(![self.connectedClients containsObject:peerID]) {
                
                [self.connectedClients addObject:peerID];
                [self.delegate planningPokerServer:self connectedToClient:peerID];
            }
            
            break;
        case GKPeerStateDisconnected:
            //Client has disconnected from server
            NSLog(@"GKPeerStateDisconnected");
            
            NSAssert(serverState != ServerStateIdle, @"Wrong state!!");
            
            if([self.connectedClients containsObject:peerID]) {

                [self.connectedClients removeObject:peerID];
                [self.delegate planningPokerServer:self disconnetedFromClient:peerID];
            }
            
            break;
        case GKPeerStateConnecting:
            NSLog(@"GKPeerStateConnecting");
            break;
    }
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID {
	NSLog(@"PlanningPokerServer: received connection request from peer %@", peerID);
    
    NSAssert(serverState == ServerStateAcceptingConnections, @"Wrong state!!");
    
    if([self.connectedClients count] < self.maxClients) {
        NSError *error;
        
        if([session acceptConnectionFromPeer:peerID error:&error]) {
            NSLog(@"Connection accepted from %@", peerID);
        } else {
            NSLog(@"Connection error from peer: %@ with error: %@", peerID, error);
        }
    } else {
        NSLog(@"Denied connection...too many devices");
    }
}

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error {
    NSLog(@"PlanningPokerServer: connection with peer %@ failed %@", peerID, error);
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error {
	NSLog(@"PlanningPokerServer: session failed %@", error);
    
    if ([[error domain] isEqualToString:GKSessionErrorDomain]) {
        if([error code] == GKSessionCannotEnableError) {
            
            [self.delegate planningPokerServer:self withErrorReason:ErrorReasonNoNetworkCapabilities];
            
            [self endBroadcasting];
        }
    }
}

- (ServerState) getState {
    return serverState;
}


@end
