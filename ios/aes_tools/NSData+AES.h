//
//  NSData+AES.h
//  UniSDKDemo
//
//  Created by 乔春晓 on 2019/11/20.
//  Copyright © 2019 乔春晓. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>


NS_ASSUME_NONNULL_BEGIN

@interface NSData (AES)
- (NSData *)AES128DecryptWithKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
