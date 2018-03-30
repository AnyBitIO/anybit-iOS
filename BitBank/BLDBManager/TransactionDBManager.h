//
//  TransactionDBManager.h
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/23.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TranModel.h"

@interface TransactionDBManager : NSObject

+ (BOOL)insertTransactionDBWithModel:(TranModel *)model coinType:(NSString*)coinType;

+ (NSMutableArray *)queryAllTransactionWithCoinType:(NSString*)coinType;

+ (BOOL)deleteAllTransaction;

@end
