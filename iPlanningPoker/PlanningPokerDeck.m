//
//  PlanningPokerDeck.m
//  iPlanningPoker
//
//  Created by Denis Arsenault
//  Copyright (c) mybrightzone All rights reserved.
//

#import "PlanningPokerDeck.h"

@implementation PlanningPokerDeck

PlanningPokerDeckState planningPokerDeckState;

- (id)init
{
	if ((self = [super init]))
	{
		self.teamMembers = [NSMutableDictionary dictionary];
	}
	return self;
}

#pragma mark - PlanningPokerDeck logic

- (void)startPlanningWithSession:(GKSession *)session clients:(NSArray *)clients{
    
    self.session = session;
    
    self.session.delegate = self;
    self.session.available = FALSE;
    
    [self.session setDataReceiveHandler:self withContext:nil];
    
    planningPokerDeckState = PlanningPokerDeckWaitingForSignIn;
    
    for(NSString *peerId in clients) {
        
        TeamMember *teamMember = [[TeamMember alloc] init];
        teamMember.peerID = peerId;
        teamMember.name = [self.session displayNameForPeer:peerId];
        
        [self.teamMembers setObject:teamMember forKey:peerId];
    }
    
    DataPacket *dataPacket = [DataPacket dataPacketWithType:DataPacketTypeSignInRequest];
    [self sendDataPacketToAllPeers:dataPacket];
}

- (void)playNewRound {
    DataPacket *datapacket = [DataPacket dataPacketWithType:DataPacketTypeNewRound];
    [self sendDataPacketToAllPeers:datapacket];
}

- (void)stopPlanningWithReason:(ErrorReason)errorReason {
    
    planningPokerDeckState = PlanningPokerDeckStopping;
    
    if (errorReason == ErrorReasonUserQuits) {
        DataPacket *dataPacket = [DataPacket dataPacketWithType:DataPacketTypeServerQuit];
        [self sendDataPacketToAllPeers:dataPacket];
    }
    
    [self.session disconnectFromAllPeers];
    self.session.delegate = nil;
    self.session = nil;
    
    [self.delegate stopPlanning:self withReason:errorReason];
}

- (void)teamMemberDidDisconnect:(NSString *)peerId {
    
    TeamMember *member = [self.teamMembers objectForKey:peerId];
    
    if(member != nil) {
        [self.teamMembers removeObjectForKey:peerId];
        
        if([self.teamMembers count] > 0) {
            //we still have users
            
            [self.delegate disconnectedTeamMember:member];
        } else {
            //close deck view;
            [self stopPlanningWithReason:ErrorReasonServerQuits];
        }
    }
}

#pragma mark - Networking

- (void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context {
    NSLog(@"data received: %@ from peer: %@", [data description], peer);
    
    DataPacket *dataPacket = [DataPacket dataPacketWithData:data];
    
    if(!dataPacket) {
        NSLog(@"Illeagl data packet");
        return;
    }
    
    TeamMember *member = [self.teamMembers objectForKey:peer];
    if(member != nil) {
        member.receivedResponse = YES;
    }
    
    [self receivedDataPacket:dataPacket fromTeamMember:member];
}

- (void)receivedDataPacket:(DataPacket *)dataPacket fromTeamMember:(TeamMember *)teamMember{
    
    switch(dataPacket.dataPacketType) {
        case DataPacketTypeSignInResponse: {
            NSAssert(planningPokerDeckState == PlanningPokerDeckWaitingForSignIn, @"Wrong state!!");
            
            NSLog(@"Sign in response from %@", [self.session displayNameForPeer:dataPacket.payload]);
            
            if([self receivedResponsesFromAllTeamMember]) {
                NSLog(@"All team members have logged in");
                
                planningPokerDeckState = PlanningPokerDeckWaitingForCardValues;
                
                DataPacket *dataPacket = [DataPacket dataPacketWithType:DataPacketTypeServerReady];
                [self sendDataPacketToAllPeers:dataPacket];
                
                [self beginPlanningPoker];
            }
            
            break;
        }
            
        case DataPacketTypeCardValue: {
            
            NSAssert(teamMember != nil, @"Teammember can't be nil");
            
            teamMember.cardValue = dataPacket.payload;
            
            if([self receivedResponsesFromAllTeamMember]) {
                NSLog(@"All team members have choosen");
                
                planningPokerDeckState = PlanningPokerDeckShowCardValues;
                
                DataPacket *dataPacket = [DataPacket dataPacketWithType:DataPacketTypeShowingCardValues];
                [self sendDataPacketToAllPeers:dataPacket];
                
                [self.delegate displayChoosenCards];
            }
            
            break;
        }
            
        case DataPacketTypeUserQuit: {
            NSAssert(planningPokerDeckState != PlanningPokerDeckStopping, @"Wrong state!!");
            
            [self teamMemberDidDisconnect:dataPacket.payload];
            
            break;
        }
        default:
            NSLog(@"unexcpected packet type");
            break;
    }
}

- (void)beginPlanningPoker {
    
    NSLog(@"the planning pokers begins");
    
    [self.delegate connectionEstablished];
}

- (void)sendDataPacketToAllPeers:(DataPacket *)dataPacket {
    
    //set received response of all clients to no
    [self.teamMembers enumerateKeysAndObjectsUsingBlock:^(id key, TeamMember *obj, BOOL *stop) {
        obj.receivedResponse = FALSE;
    }];
    
    NSError *error;
    
    if(![self.session sendDataToAllPeers:[dataPacket getDataPacketData] withDataMode:GKSendDataReliable error:&error]) {
        NSLog(@"Error sending Data to all peers: %@", error);
    }

}

- (BOOL)receivedResponsesFromAllTeamMember {
    
    __block BOOL result = TRUE;
    
    [self.teamMembers enumerateKeysAndObjectsUsingBlock:^(id key, TeamMember *obj, BOOL *stop) {
        if(!obj.receivedResponse) {
            result = FALSE;
            *stop = TRUE;
        }
    }];
    
    return result;
}

#pragma mark - GKSessionDelegate

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state {
    NSLog(@"PlanningPokerServer: peer %@ changed state %d", peerID, state);
    
    //check the state
    switch(state) {
        case GKPeerStateAvailable:
            //New server available
            NSLog(@"GKPeerStateAvailable");
            break;
        case GKPeerStateUnavailable:
            //Server is no longer available
            NSLog(@"GKPeerStateUnavailable");
            break;
        case GKPeerStateConnected:
            //client is connected to server
            NSLog(@"GKPeerStateConnected");
            break;
        case GKPeerStateDisconnected: {
            NSLog(@"GKPeerStateDisconnected");
            
            NSAssert(planningPokerDeckState != PlanningPokerDeckStopping, @"Wrong state!!");
            
            TeamMember *member = [self.teamMembers objectForKey:peerID];
            
            if(member != nil) {
                [self.delegate disconnectedTeamMember:member];
                [self.teamMembers removeObjectForKey:peerID];
            }
            
            break;
        }
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
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error {
	NSLog(@"PlanningPokerServer: session failed %@", error);
}

- (PlanningPokerDeckState) getState {
    return planningPokerDeckState;
}

@end
