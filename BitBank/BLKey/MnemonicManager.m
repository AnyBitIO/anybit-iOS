//
//  MnemonicManager.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/5.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "MnemonicManager.h"
#import "NYMnemonic.h"
#import "NSString+Base58.h"
#import "NSData+Hash.h"
#import "NSString+Utility.h"

@implementation MnemonicManager
    
+(NSString *)getMnemonicWords
{
    return [NYMnemonic generateMnemonicString:[[NSNumber alloc]initWithInt:192] language:@"english"];
}

+(NSString *)getWalletIdWithMnemonicWords:(NSString*)mnemonicWords
{
    NSData *data = [mnemonicWords dataUsingEncoding:NSUTF8StringEncoding];
    NSData *walletData = data.SHA256_2.RMD160;
    NSString *walletId = [NSString hexWithData:walletData];
    return [walletId lowercaseString];
}

+(NSString *)getSeedKeyWithMnemonicWords:(NSString*)mnemonicWords
{
    NSString *seed = [NYMnemonic deterministicSeedStringFromMnemonicString:mnemonicWords passphrase:@"" language:@"english"];
    return seed;
}

@end
