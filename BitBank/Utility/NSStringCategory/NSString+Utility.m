//
//  NSString+Utility.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/1.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "NSString+Utility.h"
#import "NSData+Hash.h"
#import "NSString+Base58.h"

@implementation NSString (Utility)

+ (NSString *)stringWithoutNil:(id)string{
    NSString *tempStr = [NSString stringWithFormat:@"%@",string];
    return [NSString isBLBlankString:tempStr]?@"":tempStr;
}

+ (BOOL)isBLBlankString:(NSString *)string {
    if (string == nil || string == NULL ) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([string isEqualToString:@"<null>"]){
        return YES;
    }
    
    if ([string isEqualToString:@"(null)"]) {
        return YES;
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

+ (NSString *)stringToHash256ToHex:(NSString *)originString{
    NSData *data = [originString dataUsingEncoding:NSUTF8StringEncoding];
    NSData *hashData = data.SHA256;
    NSString *hex = [NSString hexWithData:hashData];
    return [hex lowercaseString];
}

+ (BOOL)stringWithNumbersAndLettersOrChinese:(NSString*)string{
    NSString *regex = @"^[a-zA-Z0-9\u4e00-\u9fa5]+$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if([pred evaluateWithObject:string]){
        return YES;
    }
    return NO;
}

+ (BOOL)stringWithNumbersAndDot:(NSString*)string{
    NSString *regex = @"^[0-9]+([.]{0,1}[0-9]+){0,1}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if([pred evaluateWithObject:string]){
        return YES;
    }
    return NO;
}

+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate{
    NSArray *weekdays = [NSArray arrayWithObjects:@"", Localized(@"common_sunday"), Localized(@"common_monday"), Localized(@"common_tuesday"), Localized(@"common_wednesday"), Localized(@"common_thursday"), Localized(@"common_friday"), Localized(@"common_saturday"), nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
}


- (CGFloat)heightForWidth:(CGFloat)width withFont:(UIFont*)font
{
    NSAssert(font, @"heightForWidth:方法必须传进font参数");
    
    CGSize size = CGSizeZero;
    NSDictionary *attribute = @{NSFontAttributeName: font};
    size = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                              options: NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return ceilf(size.height)+1;
}

- (CGSize)sizeForWidth:(CGFloat)width withFont:(UIFont*)font
{
    NSAssert(font, @"heightForWidth:方法必须传进font参数");
    
    CGSize size = CGSizeZero;
    NSDictionary *attribute = @{NSFontAttributeName: font};
    size = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                              options: NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    size.height = ceilf(size.height)+1;
    size.width = ceilf(size.width);
    return size;
}

- (CGFloat)singleWidthWithMaxWidth:(CGFloat)width withFont:(UIFont*)font
{
    NSAssert(font, @"singleWidthWithMaxWidth:方法必须传进font参数");
    
    CGSize size = CGSizeZero;
    NSDictionary *attribute = @{NSFontAttributeName: font};
    size = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                              options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    return ceilf(size.width);
}


/** 根据字符串、最大尺寸、字体计算字符串最合适尺寸 */
-(CGSize)CGSizeOfStringWithSize:(CGSize)maxSize Font:(UIFont *)font
{
    CGSize fitSize;
    UIDevice *device = [UIDevice currentDevice];
    NSString *versionStr = [device systemVersion];
    float version = [versionStr floatValue];
    if (version >= 7.0) {
        NSStringDrawingOptions options = NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin;
        NSDictionary *attributes = @{NSFontAttributeName: font};
        CGRect rect = [self boundingRectWithSize:maxSize options:options attributes:attributes context:nil];
        fitSize = CGSizeMake(rect.size.width, rect.size.height);
    } else {
        fitSize = [self sizeWithFont:font constrainedToSize:maxSize];
    }
    return fitSize;
}



- (CGFloat)singleHeightWithFont:(UIFont*)font
{
    NSAssert(font, @"singleHeightWithFont:方法必须传进font参数");
    
    CGSize size = CGSizeZero;
    NSDictionary *attribute = @{NSFontAttributeName: font};
    size = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                              options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    return ceilf(size.height);
}


-(CGFloat)widthForHeight:(CGFloat)height withFont:(UIFont *)font
{
    NSAssert(font, @"heightForWidth:方法必须传进font参数");
    
    CGSize size = CGSizeZero;
    NSDictionary *attribute = @{NSFontAttributeName: font};
    size = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                              options: NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return ceilf(size.width)+1;
    
}



- (CGSize)singleSizeWithFont:(UIFont*)font
{
    NSAssert(font, @"singleHeightWithFont:方法必须传进font参数");
    
    CGSize size = CGSizeZero;
    NSDictionary *attribute = @{NSFontAttributeName: font};
    size = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                              options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    size.height = ceilf(size.height);
    size.width = ceilf(size.width);
    
    return size;
}

+ (NSString *)stringWithoutSpaceWithString:(NSString *)originalString{
    
    originalString = [originalString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    originalString = [originalString stringByReplacingOccurrencesOfString:@" "withString:@""];
    
    return originalString;
}

@end
