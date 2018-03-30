//
//  BLUnitsMethods.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/1.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "BLUnitsMethods.h"

@implementation BLUnitsMethods

+ (void)drawTheBackBarBtn:(UIViewController *)control target:(UIViewController *)target action:(SEL)action
{
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:ImageNamed(@"back") style:UIBarButtonItemStylePlain target:target action:action];
    control.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

+(void)drawTheRightBarBtnWithTitle:(NSString *)title target:(UIViewController *)target action:(SEL)action
{
    UIBarButtonItem *rightBarButtonItem  = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
    target.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

+(void)drawTheRightBarBtnWithImage:(UIImage *)image target:(UIViewController *)target action:(SEL)action
{
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:target action:action];
    target.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

+ (void)limitInputTextWithTextView:(UITextView *)textView limit:(NSInteger)limit
{
    NSRange textRange = [textView selectedRange];
    
    UITextRange *selectedRange = [textView markedTextRange];
    // 获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    
    // 如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    
    NSString *lang = [textView.textInputMode primaryLanguage]; // 键盘输入模式
    
    if ([lang isEqualToString:@"dictation"])
    {
        // 语音输入  textview调用setText  iOS7会有崩溃问题
    }
    else
    {
        NSString *newString = [BLUnitsMethods disable_emoji:textView.text];
        
        if (newString.length > limit) {
            textView.text = [newString substringToIndex:limit];
        }
        else {
            textView.text = newString;
        }
    }
    
    [textView setSelectedRange:textRange];    //为了将光标定位在我们选择的地方
}

// 屏蔽emoji表情输入
+ (NSString *)disable_emoji:(NSString *)text
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString            *modifiedString = [regex stringByReplacingMatchesInString:text options:0 range:NSMakeRange(0, [text length]) withTemplate:@""];
    
    return modifiedString;
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark  获取当前用户文件目录（如没有则创建）
+ (NSString *)userFilePath{
    // 初始化documents目录
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    // 设置用户保存的文件夹
    NSString *userPath = [documentPath stringByAppendingPathComponent:@"anybit"];
    // 创建文件管理器
    NSFileManager   *fileManager = [NSFileManager defaultManager];
    BOOL userPathExists = [fileManager fileExistsAtPath:userPath];
    
    if (!userPathExists) {
        [fileManager createDirectoryAtPath:userPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return userPath;
}

#pragma mark  获取当前document文件目录
+ (NSString *)userDocumentPath{   // 初始化documents目录
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    // 设置用户保存的文件夹
    
    return documentPath;
}

@end
