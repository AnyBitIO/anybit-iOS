//
//  NSString+Utility.h
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/1.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utility)

+ (NSString *)stringWithoutNil:(id)string;

+ (BOOL)isBLBlankString:(NSString *)string;

+ (BOOL)stringWithNumbersAndLettersOrChinese:(NSString*)string;

+ (BOOL)stringWithNumbersAndDot:(NSString*)string;

+ (NSString *)stringToHash256ToHex:(NSString *)originString;

+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate;

- (CGFloat)heightForWidth:(CGFloat)width withFont:(UIFont*)font;

- (CGSize)sizeForWidth:(CGFloat)width withFont:(UIFont*)font;

- (CGFloat)singleWidthWithMaxWidth:(CGFloat)width withFont:(UIFont*)font;

- (CGFloat)singleHeightWithFont:(UIFont*)font;

- (CGSize)singleSizeWithFont:(UIFont*)font;

- (CGFloat)widthForHeight:(CGFloat)height withFont:(UIFont *)font;

- (CGSize)CGSizeOfStringWithSize:(CGSize)maxSize Font:(UIFont *)font;

+ (NSString *)stringWithoutSpaceWithString:(NSString *)originalString;

@end
