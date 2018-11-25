//
//  PlanningPokerDeckTest.m
//  iPlanningPoker
//
//  Created by Denis Arsenault
//  Copyright (c) mybrightzone All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PlanningPokerDeck.h"
#import "TeamMember.h"
#import "DataPacket.h"

@interface PlanningPokerDeckTest : XCTestCase

@property (strong, nonatomic) PlanningPokerDeck *deck;

@end

@implementation PlanningPokerDeckTest

TeamMember *member;

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.deck = [[PlanningPokerDeck alloc] init];
    member = [[TeamMember alloc] init];
    member.peerID = @"mock";
    member.name = @"test";
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPlanningPokerDeckWaitingForSignIn
{
    XCTAssertNotNil(self.deck);
    
    [self startPlanning];
    
    XCTAssertEqual([self.deck getState], PlanningPokerDeckWaitingForSignIn, @"Deck should wait for sign in");
    
}

- (void)testPlanningPokerDeckWaitingForCardValues
{
    XCTAssertNotNil(self.deck);
    
    [self startPlanning];
    [self waitForValues];
    
    XCTAssertEqual([self.deck getState], PlanningPokerDeckWaitingForCardValues, @"Deck should wait for card values");
    
}

- (void)testPlanningPokerDeckShowCardValues
{
    XCTAssertNotNil(self.deck);
    
    [self startPlanning];
    [self waitForValues];
    
    DataPacket *dataPacket = [DataPacket dataPacketWithType:DataPacketTypeCardValue];
    
    [self receivedAnswer];
    [self.deck receivedDataPacket:dataPacket fromTeamMember:member];
    
    
    XCTAssertEqual([self.deck getState], PlanningPokerDeckShowCardValues, @"Deck should wait for card values");
    
}

- (void)testPlanningPokerDeckStopping
{
    XCTAssertNotNil(self.deck);
    
    [self.deck stopPlanningWithReason:ErrorReasonUserQuits];
    
    XCTAssertEqual([self.deck getState], PlanningPokerDeckStopping, @"Deck should wait for card values");
    
}

- (void)startPlanning {
    [self.deck startPlanningWithSession:nil clients:[NSArray arrayWithObject:@"mock"]];
}

- (void)receivedAnswer {
    TeamMember *receivedMember = [self.deck.teamMembers objectForKey:@"mock"];
    receivedMember.receivedResponse = YES;
}

- (void)waitForValues {
    DataPacket *dataPacket = [DataPacket dataPacketWithType:DataPacketTypeSignInResponse];
    
    [self receivedAnswer];
    [self.deck receivedDataPacket:dataPacket fromTeamMember:member];
}

@end
