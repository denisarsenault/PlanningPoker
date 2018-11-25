//
//  PlanningPokerClient.m
//  iPlanningPoker
//
//  Created by Denis Arsenault on 03/11/14
//  Copyright (c) mybrightzone All rights reserved.
//

#import "PlanningPokerClient.h"

@implementation PlanningPokerClient

ClientState clientState;

- (id)init {
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    clientState = ClientStateIdle;
    
    return self;
}

- (void)startLookingForServersWithSessionId:(NSString *)sessionId andName:(NSString *)name{
    
    NSAssert(clientState == ClientStateIdle, @"Wrong state!!");
    
    clientState = ClientStateLookingForServers;
    
    self.availableServers = [NSMutableArray arrayWithCapacity:kMaxAvailableServers];
    
    self.session = [[GKSession alloc] initWithSessionID:sessionId displayName:name sessionMode:GKSessionModeClient];
    self.session.delegate = self;
    self.session.available = YES;
}

- (void)connectToServerWithPeerId:(NSString *)peerId {
    
    NSAssert(clientState == ClientStateLookingForServers, @"Wrong state!!");
    
    clientState = ClientStateConnecting;
    self.serverPeerId = peerId;
    
    [self.session connectToPeer:self.serverPeerId withTimeout:self.session.disconnectTimeout];
}

- (void)disconnectFromServer {
    
    clientState = ClientStateIdle;
    
    [self.session disconnectFromAllPeers];
    self.session.available = FALSE;
    self.session.delegate = nil;
    self.session = nil;
    
    self.availableServers = nil;
    
    [self.delegate planningPokerClient:self disconnectedFromServer:self.serverPeerId];
    self.serverPeerId = nil;
}


#pragma mark - GKSessionDelegate

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state {
    NSLog(@"PlanningPokerServer: peer %@ changed state %d", peerID, state);
    
    //check the state
    switch(state) {
        case GKPeerStateAvailable:
            //New server available
            NSLog(@"GKPeerStateAvailable");
            
            NSAssert(clientState == ClientStateLookingForServers, @"Wrong state!!");
            
            if (![self.availableServers containsObject:peerID]) {
                [self.availableServers addObject:peerID];
                [self.delegate planningPokerClient:self serverBecameAvailable:peerID];
            }
            
            break;
        case GKPeerStateUnavailable:
            //Server is no longer available
            NSLog(@"GKPeerStateUnavailable");
            
            //Server disappears while connecting!
            if (clientState == ClientStateConnecting && [peerID isEqualToString:self.serverPeerId])
			{
				[self disconnectFromServer];
                break;
			}
            
            NSAssert(clientState == ClientStateLookingForServers, @"Wrong state!!");
            
            if ([self.availableServers containsObject:peerID]) {
                [self.availableServers removeObject:peerID];
                [self.delegate planningPokerClient:self serverBecameUnavailable:peerID];
            }
            
            break;
        case GKPeerStateConnected:
            //client is connected to server
            NSLog(@"GKPeerStateConnected");
            
            NSAssert(clientState == ClientStateConnecting, @"Wrong state!!");
            
            clientState = ClientStateConnected;
            
            [self.delegate didConnectToServer];
            
            break;
        case GKPeerStateDisconnected:
            NSLog(@"GKPeerStateDisconnected");
            
            NSAssert(clientState == ClientStateConnected, @"Wrong state!!");
            
            [self.delegate planningPokerClient:self withErrorReason:ErrorReasonServerQuits];
            [self disconnectFromServer];
            
            break;
        case GKPeerStateConnecting:
            NSLog(@"GKPeerStateConnecting");
            break;
    }
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID {
	NSLog(@"PlanningPokerServer: received connection request from peer %@", peerID);
}

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error {
    NSLog(@"PlanningPokerServer: connection with peer %@ failed %@", peerID, error);
    
    NSAssert(clientState != ClientStateIdle, @"Wrong state!!");
    
    [self disconnectFromServer];
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error {
	NSLog(@"PlanningPokerServer: session failed %@", error);
    
    if ([[error domain] isEqualToString:GKSessionErrorDomain]) {
        if([error code] == GKSessionCannotEnableError) {
            
            [self.delegate planningPokerClient:self withErrorReason:ErrorReasonNoNetworkCapabilities];
            
            [self disconnectFromServer];
        }
    }
}

- (ClientState) getState {
    return clientState;
}

@end
