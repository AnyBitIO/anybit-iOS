//
//  BLKeyManager.h
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/6.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLKeyManager : NSObject

/**
 *   只支持BTC, BCC, BTG, SBTC, BTW, BCD, BTF, BTP, BTN
 */
+(NSString *)getMasterPrivateKeyWithPayPsd:(NSString*)payPsd;

+(NSString *)getPrivateKeyWithCoinType:(NSString*)coinType payPsd:(NSString*)payPsd;

+(NSString *)getPublicKeyWithCoinType:(NSString*)coinType payPsd:(NSString*)payPsd;

+(NSString *)getAddressWithCoinType:(NSString*)coinType payPsd:(NSString*)payPsd;


+(NSString *)getAddressWithCoinType:(NSString*)coinType mnemonicWords:(NSString *)mnemonicWords;

@end
