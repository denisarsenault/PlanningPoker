//
//  PlanningPokerServerTest.m
//  iPlanningPoker
//
//  Created by Denis Arsenault
//  Copyright (c) mybrightzone All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PlanningPokerServer.h"

@interface PlanningPokerServerTest : XCTestCase

@property (strong, nonatomic) PlanningPokerServer *server;

@end

@implementation PlanningPokerServerTest

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    self.server = [[PlanningPokerServer alloc] init];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testServerStateIdle
{
    XCTAssertNotNil(self.server);
    
    XCTAssertEqual([self.server getState], ServerStateIdle, @"Server should be in idle state");
}

- (void)testServerStateAcceptingConnections
{
    XCTAssertNotNil(self.server);
    
    [self startBroadcasting];
    
    XCTAssertEqual([self.server getState], ServerStateAcceptingConnections, @"Server should accept new connections");
}

- (void)testServerStopAcceptingConnectionsThrows
{
    XCTAssertNotNil(self.server);
  
    XCTAssertThrows([self.server stopAcceptingNewConnections], @"should have been the wrong state");
}

- (void)testServerStopAcceptingConnections
{
    XCTAssertNotNil(self.server);
    
    [self startBroadcasting];
    [self.server stopAcceptingNewConnections];
    
    XCTAssertEqual([self.server getState], ServerStateStopAcceptingNewConnections, @"Server should not accept new connections");
}

- (void)startBroadcasting {
    [self.server startBroadcastingForSessionId:@"mock"];
}

@end
