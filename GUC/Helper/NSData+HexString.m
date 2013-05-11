//
//  NSData+HexString.m
//  GUC
//
//  Created by Michael Brodeur on 5/10/13.
//  Copyright (c) 2013 SmashingBoxes. All rights reserved.
//

#import "NSData+HexString.h"

@implementation NSData (HexString)

-(id)initWithHexString:(NSString *)hexString{
    NSMutableData *returnedBytes = [[NSMutableData alloc] init];
    
    if(self == [super init]){
        NSString *trimmedString = [hexString stringByReplacingOccurrencesOfString:@" " withString:@""];
        trimmedString = [trimmedString stringByReplacingOccurrencesOfString:@"<" withString:@""];
        trimmedString = [trimmedString stringByReplacingOccurrencesOfString:@">" withString:@""];
        unsigned char whole_byte;
        char byte_chars[3] = {'\0','\0','\0'};
        int i;
        for (i = 0; i < abs([trimmedString length]/2); i++) {
            byte_chars[0] = [trimmedString characterAtIndex:i*2];
            //NSLog(@"First byte set.");
            byte_chars[1] = [trimmedString characterAtIndex:i*2+1];
            //NSLog(@"Second byte set.");
            whole_byte = strtol(byte_chars, NULL, 16);
            [returnedBytes appendBytes:&whole_byte length:1];
        }
    }
    
    return returnedBytes;
}

@end
