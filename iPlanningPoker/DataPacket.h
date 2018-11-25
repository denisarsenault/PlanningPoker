//
//  DataPacket.h
//  iPlanningPoker
//
//  Created by Denis Arsenault
//  Copyright (c) mybrightzone All rights reserved.
//

#import "NSMutableData+iPPr.h"
#import "NSData+iPPr.h"

#import <Foundation/Foundation.h>

typedef enum {
    DataPacketTypeSignInRequest = 0x01,
    DataPacketTypeSignInResponse = 0x02,
    DataPacketTypeServerReady = 0x03,
    DataPacketTypeServerQuit = 0x04,
    DataPacketTypeUserQuit = 0x05,
    DataPacketTypeCardValue = 0x06,
    DataPacketTypeShowingCardValues = 0x07,
    DataPacketTypeNewRound = 0x08
} DataPacketType;

@interface DataPacket : NSObject

@property (assign, nonatomic) DataPacketType dataPacketType;
@property (strong, nonatomic) NSString* payload;

+ (id)dataPacketWithType:(DataPacketType)dataPacketType;
+ (id)dataPacketWithType:(DataPacketType)dataPacketType andPayload:(NSString *)payload;
+ (id)dataPacketWithData:(NSData *)data;

- (id)initWithType:(DataPacketType)dataPacketType andPayload:(NSString *)payload;

- (NSData *)getDataPacketData;

@end
