//
//  BLOther.h
//  BitBank
//
//  Created by 张蒙蒙 on 2018/2/7.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#ifndef BLOther_h
#define BLOther_h


// 屏幕宽度
// 设备屏幕frame
#define kMainScreenFrameRect                            [[UIScreen mainScreen] bounds]
// 状态栏高度
#define kMainScreenStatusBarFrameRect                   [[UIApplication sharedApplication] statusBarFrame]


// 判断是否是iPhone X
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
// 状态栏高度
#define STATUS_BAR_HEIGHT (iPhoneX ? 44.f : 20.f)
// 导航栏高度
#define NAVIGATION_BAR_HEIGHT (iPhoneX ? 88.f : 64.f)
// tabBar高度
#define TAB_BAR_HEIGHT (iPhoneX ? (49.f+34.f) : 49.f)
// home indicator
#define HOME_INDICATOR_HEIGHT (iPhoneX ? 34.f : 0.f)

//适配iPhone X 距离顶部的高度
#define fit_X_width  (iPhoneX ? 24.f : 0.f)


// 屏幕高度度和宽度
#define kMainScreenHeight                               [[UIScreen mainScreen] bounds].size.height// [[UIScreen mainScreen] applicationFrame].size.height
#define kMainScreenWidth                                [[UIScreen mainScreen] bounds].size.width

// 减去状态栏的高度:应用有效高度-状态栏的高度
#define kScreenHeightNoStatusBarHeight                  (kMainScreenFrameRect.size.height - kMainScreenStatusBarFrameRect.size.height)
// 减去状态栏和导航栏的高度
#define kScreenHeightNoStatusAndNoNaviBarHeight         (kMainScreenFrameRect.size.height - kMainScreenStatusBarFrameRect.size.height - 44.0f)

// 减去状态栏和导航栏的高度和tabbar的高度
#define kScreenHeightNoStatusAndNoNaviBarNOTabBarHeight (kMainScreenFrameRect.size.height - kMainScreenStatusBarFrameRect.size.height - 44.0f - 49.0f) //83

// 应用有效高度-减去状态栏-tabbar的高度
#define kScreenHeightNoStatusAndNOTabBarHeight                  (kMainScreenFrameRect.size.height- kMainScreenStatusBarFrameRect.size.height - 49.0f)

#define KScreenTabBarHeight                             49.0f

#define kScreenHeight                                   [[UIScreen mainScreen] applicationFrame].size.height

#define CurrentSystemVersion                            ([[[UIDevice currentDevice] systemVersion] floatValue])

// 颜色的定义 HEX Color
#define UIColorFromRGB(rgbValue)        [UIColor colorWithRed: ((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green: ((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue: ((float)(rgbValue & 0xFF)) / 255.0 alpha: 1.0]
#define RGB(r, g, b)                        [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:1.f]
#define RGBA(r, g, b, a)                    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define SYS_FONT(FontValue)         [UIFont systemFontOfSize:FontValue]
#define SYS_BOLD_FONT(FontValue)    [UIFont boldSystemFontOfSize:FontValue]

#define  kDEFAULT_DATE_TIME_FORMAT (@"yyyy-MM-dd HH:mm")
#define  kDEFAULT_MSG_DATE_TIME_FORMAT (@"yyyy-MM-dd HH:mm:ss")
#define  YB_UNIVERSALDATEFORMAT (@"yyyyMMddHHmmssSSS")

#endif /* BLOther_h */
