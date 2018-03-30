//
//  MnemonicManager.h
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/5.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MnemonicManager : NSObject

/*
 * 助记词  12个单词
 */
+(NSString *)getMnemonicWords;

/*
 * 钱包ID  助记词->hash256->hex
 */
+(NSString *)getWalletIdWithMnemonicWords:(NSString*)mnemonicWords;

/*
 * 种子密钥  助记词->种子密钥
 */
+(NSString *)getSeedKeyWithMnemonicWords:(NSString*)mnemonicWords;

@end
