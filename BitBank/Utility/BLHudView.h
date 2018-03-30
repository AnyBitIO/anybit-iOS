//
//  BLHudView.h
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/6.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

#define _DEVICE_WIDTH   [[UIScreen mainScreen] bounds].size.width
#define _DEVICE_HEIGHT  [[UIScreen mainScreen] bounds].size.height
#define _DEVICE_HEIGHT_NO_20    [[UIScreen mainScreen] bounds].size.height - 20
#define _DEVICE_HEIGHT_NO_64    [[UIScreen mainScreen] bounds].size.height - 64

#define _APP_KEYWINDOW  [UIApplication sharedApplication].keyWindow

typedef void(^OverTimeBlock)(void);

@interface BLHudView : NSObject
{
    UIView * _hudSubView;
    NSTimer * _timer;
}

@property (nonatomic, assign) BOOL isUserEnable;
@property (nonatomic, strong) OverTimeBlock overTimeBlock;
@property (nonatomic, strong, readonly) MBProgressHUD * mbProgressHud;
@property (nonatomic, strong) UIView * hudView;

@property (nonatomic, strong) UIViewController * currentVC;

#pragma mark - class method -
/**
 *  覆盖 + （右侧键不隐藏）
 */
+ (void)linkerUnEnableHUDShowToViewController:(UIViewController *)viewController;
/**
 *  覆盖 + （右侧键选择隐藏）
 */
+ (void)linkerUnEnableHUDShowToViewController:(UIViewController *)viewController
                           enableRightBarBtn:(BOOL)enable;
/**
 *  覆盖 + 超时后事件
 */
+ (void)linkerUnEnableHUDShowToViewController:(UIViewController *)viewController
                               overTimeBlock:(OverTimeBlock)overTimeBlock;
/**
 *  提示框 + （右侧键显示）
 */
+ (void)linkerHUDStopOrShowWithMsg:(NSString*)msg
                            finsh:(void (^)(void))finshBlock;
/**
 *  移除
 */
+ (void)linkerHUDHide;


@end
