//
//  BLString.h
//  BitBank
//
//  Created by 张蒙蒙 on 2018/2/28.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "Bitheri.h"

#ifndef BLString_h
#define BLString_h

#define BL_WalletId [BLWalletModel shareInstance].walletId

#define ImageNamed(name) [UIImage  imageNamed:name]

#define Localized(key)  [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"]] ofType:@"lproj"]] localizedStringForKey:(key) value:nil table:@"Localizable"]

#define TAB_BAR_SELECT_COLOR  UIColorFromRGB(0x02a4ff)
#define TAB_BAR_NORMAL_COLOR  UIColorFromRGB(0xbebebe)
#define LINE_COLOR UIColorFromRGB(0xd6d6d7)


//通知
static NSString *const NotifyLanguageChanged = @"NotifyLanguageChanged"; //语言改变通知
static NSString *const NotifyManagerCoin = @"NotifyManagerCoin"; //管理货币通知
static NSString *const NotifyChangeDefaultCoin = @"NotifyChangeDefaultCoin"; //修改默认货币通知
static NSString *const NotifyPaySuccess = @"NotifyPaySuccess"; //支付成功通知
static NSString *const NotifyChangeWallet = @"NotifyChangeWallet"; //修改钱包名称

//NSUserDefaults
static NSString *const NDappLanguage = @"appLanguage";//当前语言


#define BL_HTTP_CODE_OK                        @"1"//回调成功
#define BL_HTTP_CODE_NOT_NET                   @"383838"//没有网络
#define BL_HTTP_CODE_NOT_SERVER                @"838383"//服务端网络异常
#define BL_HTTP_CODE_ERR                       @"errCode"
#define BL_HTTP_CODE_RTN                       @"rtnCode"
#define BL_HTTP_MSG_ERR                        @"errMsg"

#endif /* BLString_h */
