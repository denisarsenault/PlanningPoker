//
//  NSData+iPPr.m
//  iPlanningPoker
//
//  Created by Denis Arsenault
//  Copyright (c) mybrightzone All rights reserved.
//

#import "NSData+iPPr.h"

@implementation NSData (iPPr)

- (int)int32AtOffset:(size_t)offset {
    const int *intBytes = (const int *)[self bytes];
	
    return ntohl(intBytes[offset / 4]);
}

- (short)int16AtOffset:(size_t)offset {
    const short *shortBytes = (const short *)[self bytes];

	return ntohs(shortBytes[offset / 2]);
}

- (char)int8AtOffset:(size_t)offset {
    const char *charBytes = (const char *)[self bytes];
    
    return charBytes[offset];
}

- (NSString *)stringAtOffset:(size_t)offset bytesRead:(size_t *)amount {
    const char *charBytes = (const char *)[self bytes];
	NSString *value = [NSString stringWithUTF8String:charBytes + offset];
	return value;
}

@end
