//
//  NSData+AES256.h
//  几里
//
//  Created by 泰山金融 on 2018/8/7.
//  Copyright © 2018年 云农公社. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (AES256)
- (NSData *)aes256_encrypt:(NSString *)key;   //加密
- (NSData *)aes256_decrypt:(NSString *)key ;
@end
