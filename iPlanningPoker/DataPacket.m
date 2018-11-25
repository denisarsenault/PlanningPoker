//
//  DataPacket.m
//  iPlanningPoker
//
//  Created by Denis Arsenault
//  Copyright (c) mybrightzone All rights reserved.
//

#import "DataPacket.h"

@implementation DataPacket

const size_t DATA_PACKET_HEADER_SIZE = 6;

- (id)initWithType:(DataPacketType)dataPacketType andPayload:(NSString *)payload{
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    self.dataPacketType = dataPacketType;
    self.payload = payload;
    
    return self;

}

+ (id)dataPacketWithType:(DataPacketType)dataPacketType {
    return [DataPacket dataPacketWithType:dataPacketType andPayload:nil];
}

+ (id)dataPacketWithType:(DataPacketType)dataPacketType andPayload:(NSString *)payload{
    return [[self alloc] initWithType:dataPacketType andPayload:payload];
}

+ (id)dataPacketWithData:(NSData *)data {
    if([data length] < DATA_PACKET_HEADER_SIZE) {
        NSLog(@"dataPacket is too small");
        
        return nil;
    }
    
    NSLog(@"%i", [data int32AtOffset:0]);
    
    if([data int32AtOffset:0] != 'iPPr') {
        NSLog(@"dataPacket has an invalid header");
        
        return nil;
    }

    int packetNumber = [data int8AtOffset:4];
    NSLog(@"PacketNumber: %d", packetNumber);
    DataPacketType dataPacketType = [data int8AtOffset:5];
    size_t count;
    NSString *payload = [data stringAtOffset:DATA_PACKET_HEADER_SIZE bytesRead:&count];

    return [DataPacket dataPacketWithType:dataPacketType andPayload:(NSString *)payload];
}

- (NSData *)getDataPacketData {
    NSMutableData *data = [[NSMutableData alloc] initWithCapacity:100];
    
    [data appendInt32:'iPPr']; //0x69505072
    [data appendInt8:0];
    [data appendInt8:self.dataPacketType];
    
    if(self.payload) {
        [data appendString:self.payload];
    }
    
    return data;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ :: dataType: %d", [super description], self.dataPacketType];
}

@end
