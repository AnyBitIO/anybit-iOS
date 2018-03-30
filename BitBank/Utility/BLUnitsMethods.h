//
//  BLUnitsMethods.h
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/1.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLUnitsMethods : NSObject

/**
 * 导航左按钮(图片)
 */
+ (void)drawTheBackBarBtn:(UIViewController *)control target:(UIViewController *)target action:(SEL)action;

/**
 * 导航右按钮(文字)
 */
+(void)drawTheRightBarBtnWithTitle:(NSString *)title target:(UIViewController *)target action:(SEL)action;

/**
 * 导航右按钮(图片)
 */
+(void)drawTheRightBarBtnWithImage:(UIImage *)image target:(UIViewController *)target action:(SEL)action;

/**
 * 判断输入长度
 */
+ (void)limitInputTextWithTextView:(UITextView *)textView limit:(NSInteger)limit;

/**
 * 颜色转iamge
 */
+ (UIImage *)imageWithColor:(UIColor *)color;


+ (NSString *)userFilePath;


+ (NSString *)userDocumentPath;

@end
