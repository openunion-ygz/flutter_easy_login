//
//  NSData+AES.m
//  UniSDKDemo
//
//  Created by 乔春晓 on 2019/11/20.
//  Copyright © 2019 乔春晓. All rights reserved.
//

#import "NSData+AES.h"

@implementation NSData (AES)

- (NSData *)AES128DecryptWithKey:(NSString *)key {
    char keyPtr[kCCKeySizeAES128 + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding | kCCOptionECBMode, keyPtr, kCCBlockSizeAES128, NULL, [self bytes], dataLength, buffer, bufferSize, &numBytesDecrypted);
    if(cryptStatus == kCCSuccess){
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    free(buffer);
    return nil;
    
}

@end
