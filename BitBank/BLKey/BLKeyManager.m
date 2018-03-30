//
//  BLKeyManager.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/6.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "BLKeyManager.h"
#import "BTBIP32Key.h"
#import "NYMnemonic.h"
#import "MnemonicManager.h"
#import "BLWalletDBManager.h"
#import "AESCrypt.h"
#import "AllCoinDBManager.h"

@implementation BLKeyManager

+(NSString *)getMasterPrivateKeyWithPayPsd:(NSString*)payPsd{
    
    NSString *seed = [AESCrypt decrypt:[BLWalletDBManager getWalletSeedKey] password:payPsd];
    BTBIP32Key *master = [[BTBIP32Key alloc] initWithSeed:[seed ny_dataFromHexString]];
    return  master.key.privateKey;
}

+(NSString *)getPrivateKeyWithCoinType:(NSString*)coinType payPsd:(NSString*)payPsd{
    uint coinValue = [AllCoinDBManager queryCoinValueWithName:coinType];
    NSString *seed = [AESCrypt decrypt:[BLWalletDBManager getWalletSeedKey] password:payPsd];
    BTBIP32Key *master = [[BTBIP32Key alloc] initWithSeed:[seed ny_dataFromHexString]];
    BTBIP32Key *purpose = [master deriveSoftened:coinValue];
    if ([coinType isEqualToString:@"UBTC"]) {
        return purpose.key.privateKey;
    }else{
        return @"";
    }
}

+(NSString *)getPublicKeyWithCoinType:(NSString*)coinType payPsd:(NSString*)payPsd{
    
    uint coinValue = [AllCoinDBManager queryCoinValueWithName:coinType];
    NSString *seed = [AESCrypt decrypt:[BLWalletDBManager getWalletSeedKey] password:payPsd];
    BTBIP32Key *master = [[BTBIP32Key alloc] initWithSeed:[seed ny_dataFromHexString]];
    BTBIP32Key *purpose = [master deriveSoftened:coinValue];
    if ([coinType isEqualToString:@"UBTC"]) {
        return [purpose.key.publicKey ny_hexString];
    }else{
        return @"";
    }
}

+(NSString *)getAddressWithCoinType:(NSString*)coinType payPsd:(NSString*)payPsd{
    uint coinValue = [AllCoinDBManager queryCoinValueWithName:coinType];
    NSString *seed = [AESCrypt decrypt:[BLWalletDBManager getWalletSeedKey] password:payPsd];
    BTBIP32Key *master = [[BTBIP32Key alloc] initWithSeed:[seed ny_dataFromHexString]];
    BTBIP32Key *purpose = [master deriveSoftened:coinValue];
    if ([coinType isEqualToString:@"UBTC"]) {
       return purpose.key.address;
    }else{
        return @"";
    }
}

+(NSString *)getAddressWithCoinType:(NSString*)coinType mnemonicWords:(NSString *)mnemonicWords{
    uint coinValue = [AllCoinDBManager queryCoinValueWithName:coinType];
    NSString *seed = [MnemonicManager getSeedKeyWithMnemonicWords:mnemonicWords];
    BTBIP32Key *master = [[BTBIP32Key alloc] initWithSeed:[seed ny_dataFromHexString]];
    BTBIP32Key *purpose = [master deriveSoftened:coinValue];
    if ([coinType isEqualToString:@"UBTC"]) {
        return purpose.key.address;
    }else{
        return @"";
    }
}

@end
