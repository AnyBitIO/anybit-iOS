//
//  BTEncryptData.h
//  bitheri
//
//  Copyright 2014 http://Bither.net
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
#import <Foundation/Foundation.h>

@interface BTEncryptData : NSObject

- (instancetype)initWithStr:(NSString *)str;

- (instancetype)initWithData:(NSData *)data andPassowrd:(NSString *)password;

- (instancetype)initWithData:(NSData *)data andPassowrd:(NSString *)password andIsXRandom:(BOOL)isXRandom;

- (instancetype)initWithData:(NSData *)data andPassowrd:(NSString *)password andIsCompressed:(BOOL)isCompressed andIsXRandom:(BOOL)isXRandom;

@property(nonatomic, readonly) BOOL isXRandom;
@property(nonatomic, readonly) BOOL isCompressed;

- (NSData *)decrypt:(NSString *)password;

- (NSString *)toEncryptedString;

- (NSString *)toEncryptedStringForQRCodeWithIsCompressed:(BOOL)isCompressed andIsXRandom:(BOOL)isXRandom;

+ (NSString *)encryptedString:(NSString *)encryptedString addIsCompressed:(BOOL)isCompressed andIsXRandom:(BOOL)isXRandom;

+ (NSString *)encryptedStringRemoveFlag:(NSString *)encryptedString;

+ (NSData *)encryptSecret:(NSData *)secret withPassphrase:(NSString *)passphrase andSalt:(NSData *)salt andIV:(NSData *)iv;

+ (NSData *)decryptFrom:(NSData *)encrypted andPassphrase:(NSString *)passphrase andSalt:(NSData *)salt andIV:(NSData *)iv;

@end