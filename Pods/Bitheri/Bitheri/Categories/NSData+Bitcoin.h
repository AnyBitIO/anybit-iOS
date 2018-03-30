//
//  NSData+Bitcoin.h
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
//
//  Copyright (c) 2013-2014 Aaron Voisine <voisine@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import <Foundation/Foundation.h>

typedef union _UInt512 {
    uint8_t u8[512/8];
    uint16_t u16[512/16];
    uint32_t u32[512/32];
    uint64_t u64[512/64];
} UInt512;

typedef union _UInt256 {
    uint8_t u8[256/8];
    uint16_t u16[256/16];
    uint32_t u32[256/32];
    uint64_t u64[256/64];
} UInt256;

typedef union _UInt160 {
    uint8_t u8[160/8];
    uint16_t u16[160/16];
    uint32_t u32[160/32];
} UInt160;

typedef union _UInt128 {
    uint8_t u8[128/8];
    uint16_t u16[128/16];
    uint32_t u32[128/32];
    uint64_t u64[128/64];
} UInt128;

#define uint512_eq(a, b)\
((a).u64[0] == (b).u64[0] && (a).u64[1] == (b).u64[1] && (a).u64[2] == (b).u64[2] && (a).u64[3] == (b).u64[3] &&\
(a).u64[4] == (b).u64[4] && (a).u64[5] == (b).u64[5] && (a).u64[6] == (b).u64[6] && (a).u64[7] == (b).u64[7])
#define uint256_eq(a, b)\
((a).u64[0] == (b).u64[0] && (a).u64[1] == (b).u64[1] && (a).u64[2] == (b).u64[2] && (a).u64[3] == (b).u64[3])
#define uint160_eq(a, b)\
((a).u32[0] == (b).u32[0] && (a).u32[1] == (b).u32[1] && (a).u32[2] == (b).u32[2] && (a).u32[3] == (b).u32[3] &&\
(a).u32[4] == (b).u32[4])
#define uint128_eq(a, b) ((a).u64[0] == (b).u64[0] && (a).u64[1] == (b).u64[1])

#define uint512_is_zero(u)\
(((u).u64[0] | (u).u64[1] | (u).u64[2] | (u).u64[3] | (u).u64[4] | (u).u64[5] | (u).u64[6] | (u).u64[7]) == 0)
#define uint256_is_zero(u) (((u).u64[0] | (u).u64[1] | (u).u64[2] | (u).u64[3]) == 0)
#define uint160_is_zero(u) (((u).u32[0] | (u).u32[1] | (u).u32[2] | (u).u32[3] | (u).u32[4]) == 0)
#define uint128_is_zero(u) (((u).u64[0] | (u).u64[1]) == 0)

#define uint512_obj(u) ([NSValue value:(u).u8 withObjCType:@encode(UInt512)])
#define uint256_obj(u) ([NSValue value:(u).u8 withObjCType:@encode(UInt256)])
#define uint160_obj(u) ([NSValue value:(u).u8 withObjCType:@encode(UInt160)])
#define uint128_obj(u) ([NSValue value:(u).u8 withObjCType:@encode(UInt128)])

#define UINT512_ZERO ((UInt512) { .u64 = { 0, 0, 0, 0, 0, 0, 0, 0 } })
#define UINT256_ZERO ((UInt256) { .u64 = { 0, 0, 0, 0 } })
#define UINT160_ZERO ((UInt160) { .u32 = { 0, 0, 0, 0, 0 } })
#define UINT128_ZERO ((UInt128) { .u64 = { 0, 0 } })

#define RMD160_DIGEST_LENGTH (160/8)

#define VAR_INT16_HEADER 0xfd
#define VAR_INT32_HEADER 0xfe
#define VAR_INT64_HEADER 0xff

void SHA1(void *md, const void *data, size_t len);
void SHA256(void *md, const void *data, size_t len);
void SHA512(void *md, const void *data, size_t len);
void RMD160(void *md, const void *data, size_t len);
void HMAC(void *md, void (*hash)(void *, const void *, size_t), size_t hlen, const void *key, size_t klen,
          const void *data, size_t dlen);
void PBKDF2(void *dk, size_t dklen, void (*hash)(void *, const void *, size_t), size_t hlen,
            const void *pw, size_t pwlen, const void *salt, size_t slen, unsigned rounds);


@interface NSData (Bitcoin)

- (uint8_t)UInt8AtOffset:(NSUInteger)offset;

- (uint16_t)UInt16AtOffset:(NSUInteger)offset;

- (uint32_t)UInt32AtOffset:(NSUInteger)offset;

- (uint64_t)UInt64AtOffset:(NSUInteger)offset;

- (uint64_t)varIntAtOffset:(NSUInteger)offset length:(NSUInteger *)length;

- (NSData *)hashAtOffset:(NSUInteger)offset;

- (NSString *)stringAtOffset:(NSUInteger)offset length:(NSUInteger *)length;

- (NSData *)dataAtOffset:(NSUInteger)offset length:(NSUInteger *)length;

- (NSArray *)scriptDataElements;

@end
