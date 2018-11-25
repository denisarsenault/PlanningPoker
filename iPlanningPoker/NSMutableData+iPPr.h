//
//  NSMutableData+iPPr.h
//  iPlanningPoker
//
//  Created by Denis Arsenault
//  Copyright (c) mybrightzone All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableData (iPPr)

- (void)appendInt32:(int)value;
- (void)appendInt16:(int)value;
- (void)appendInt8:(int)value;
- (void)appendString:(NSString *)value;

@end
