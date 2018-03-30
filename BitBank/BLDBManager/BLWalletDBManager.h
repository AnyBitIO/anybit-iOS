//
//  BLWalletDBManager.h
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/19.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLWalletModel.h"

@interface BLWalletDBManager : NSObject

+ (BOOL)insertWalletDBWithWalletName:(NSString *)walletName
                          walletUrl:(NSString *)walletUrl
                           walletId:(NSString *)walletId
                      mnemonicWords:(NSString *)mnemonicWords
                            seedKey:(NSString *)seedKey
                           loginPsd:(NSString *)loginPsd
                             payPsd:(NSString *)payPsd
                  needLoginPassword:(BOOL)needLoginPassword
                          isDefault:(BOOL)isDefault;

+ (NSMutableArray *)queryWalletDBData;

+ (NSString*)getWalletId;

+ (NSString*)getWalletName;
+ (BOOL)updateWalletName:(NSString*)name;

+ (BOOL)deleteOneWalletData;

+ (BOOL)updateWalletMnemonicWords:(NSString*)mnemonicWords;
+ (NSString*)getWalletMnemonicWords;

+ (BOOL)updateWalletSeedKey:(NSString*)seedKey;
+ (NSString*)getWalletSeedKey;

+ (BOOL)updateWalletLoginPsd:(NSString*)loginPsd;
+ (NSString*)getWalletLoginPsd;

+ (BOOL)updateWalletPayPsd:(NSString*)payPsd;
+ (NSString*)getWalletPayPsd;

+ (BOOL)updateWalletNeedLoginPassword:(BOOL)isNeedLoginPassword;
+ (BOOL)getWalletNeedLoginPassword;

+ (BOOL)updateAllWalletIsDefaultNo;
+ (BOOL)updateOneWalletIsDefault:(BOOL)isDefault;

+ (BOOL)queryWalletNameIsTakenWithName:(NSString*)name;

@end
