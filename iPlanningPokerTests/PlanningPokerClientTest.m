//
//  PlanningPokerClientTest.m
//  iPlanningPoker
//
//  Created by Denis Arsenault
//  Copyright (c) mybrightzone All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PlanningPokerClient.h"

@interface PlanningPokerClientTest : XCTestCase

@property (strong, nonatomic) PlanningPokerClient *client;

@end

@implementation PlanningPokerClientTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.client = [[PlanningPokerClient alloc] init];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testClientStateIdle
{
    XCTAssertNotNil(self.client);
    
    XCTAssertEqual([self.client getState], ClientStateIdle, @"Server should be in idle state");
}

- (void)testClientStateLookingForServers
{
    XCTAssertNotNil(self.client);
    
    [self lookingForServer];
    
    XCTAssertEqual([self.client getState], ClientStateLookingForServers, @"Server should be in idle state");
}

- (void)testClientStateConnecting
{
    XCTAssertNotNil(self.client);
    
    [self connectToServer];
    
    XCTAssertEqual([self.client getState], ClientStateConnecting, @"Server should be in idle state");
}

- (void)testClientStateConnectedThrows
{
    XCTAssertNotNil(self.client);
    
    [self lookingForServer];
    
    XCTAssertThrows([self.client session:nil peer:@"123" didChangeState:GKPeerStateConnected], @"should have been the wrong state");
}

- (void)testClientStateConnected
{
    XCTAssertNotNil(self.client);
    
    [self connectToServer];
    [self.client session:nil peer:@"123" didChangeState:GKPeerStateConnected];
    
    XCTAssertEqual([self.client getState], ClientStateConnected, @"Server should be in idle state");
}

- (void)lookingForServer {
    [self.client startLookingForServersWithSessionId:@"123" andName:@"unit"];
}

- (void)connectToServer {
    [self lookingForServer];
    [self.client connectToServerWithPeerId:@"123"];
}

@end
