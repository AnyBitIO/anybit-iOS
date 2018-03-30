//
//  HoldCoinDBManager.h
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/10.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoinModel.h"

@interface HoldCoinDBManager : NSObject

+ (BOOL)insertHoldCoinDBWithModel:(CoinModel *)model;

+ (NSMutableArray *)queryAllHoldCoin;

+ (NSString *)getCoinAddressWithCoinValue:(NSInteger)coinValue;

+ (BOOL)updateHoldCoinDBWithCoinValue:(NSInteger)coinValue isDefault:(BOOL)isDefault;

+ (BOOL)deleteAllHoldCoin;

@end
