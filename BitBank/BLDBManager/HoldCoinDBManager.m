//
//  HoldCoinDBManager.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/10.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "HoldCoinDBManager.h"
#import "BLDBManager.h"
#import "FMResultSet.h"

@implementation HoldCoinDBManager

+(BOOL)insertHoldCoinDBWithModel:(CoinModel *)model{
    FMDatabaseQueue *dataQueue = [BLDBManager getDBQueue];
    __block BOOL result = NO;
    
    BOOL isExist = [self isHoldCoinWithExistModel:model];
    
    if (!isExist) {
        [dataQueue inDatabase:^(FMDatabase *db)
         {
             result = [db executeUpdate:@"INSERT INTO T_DB_HOLD_COIN (walletId,address,coinValue,coinType,isDefault) VALUES  (?,?,?,?,?)",BL_WalletId,model.address,@(model.coinValue), model.coinType,@(model.isDefault)];
             
             if (!result) {
                 DDLogInfo(@"insert HoldCoinDB failed");
             }
         }];
    }
    return result;
}


+(NSMutableArray *)queryAllHoldCoin{
    __block NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    
    FMDatabaseQueue *dataQueue = [BLDBManager getDBQueue];
    
    [dataQueue inDatabase:^(FMDatabase *db)
     {
         NSString *findSql = [NSString stringWithFormat:@"SELECT * FROM %@ where walletId ='%@' Order By coinValue DESC", @"T_DB_HOLD_COIN",BL_WalletId];
         FMResultSet *rs = [db executeQuery:findSql];
         
         while ([rs next]){
             CoinModel *model = [[CoinModel alloc]init];
             model.coinValue = [[rs stringForColumn:@"coinValue"] intValue];
             model.coinType = [rs stringForColumn:@"coinType"];
             model.address = [rs stringForColumn:@"address"];
             model.isDefault = [[rs stringForColumn:@"isDefault"] boolValue];
             [resultArray addObject:model];
         }
         
         if (rs){
             [rs close];
         }
     }];
    
    return resultArray;
}

+ (NSString*)getCoinAddressWithCoinValue:(NSInteger)coinValue{
    __block NSString *_getCoinAddress = @"";
    
    FMDatabaseQueue *dataQueue = [BLDBManager getDBQueue];
    
    [dataQueue inDatabase:^(FMDatabase *db)
     {
         NSString *findSql = [NSString stringWithFormat:@"SELECT * FROM T_DB_HOLD_COIN where coinValue = '%ld' and walletId = '%@'",coinValue,BL_WalletId];
         FMResultSet *rs = [db executeQuery:findSql];
         
         while ([rs next]){
             _getCoinAddress = [rs stringForColumn:@"address"];
         }
         
         if (rs){
             [rs close];
         }
     }];
    return _getCoinAddress;
}

+ (BOOL)updateHoldCoinDBWithCoinValue:(NSInteger)coinValue isDefault:(BOOL)isDefault{
    __block BOOL    result = NO;
    FMDatabaseQueue *dataQueue = [BLDBManager getDBQueue];
    
    [dataQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET isDefault = '%d' WHERE coinValue = '%ld' and walletId = '%@'", @"T_DB_HOLD_COIN", isDefault, (long)coinValue,BL_WalletId];
        
        result = [db executeUpdate:sql];
        
        if (!result) {
            DDLogInfo(@"update updateHoldCoinDBWithcoinValue:isDefault failed");
        }
    }];
    
    return result;
}

+ (BOOL)deleteAllHoldCoin {
    __block BOOL result;
    FMDatabaseQueue* dataQueue = [BLDBManager getDBQueue];
    
    [dataQueue inDatabase:^(FMDatabase* db)
     {
         NSString* sqlStr = [NSString stringWithFormat:@"delete from %@ where walletId ='%@' ", @"T_DB_HOLD_COIN",BL_WalletId];
         result = [db executeUpdate:sqlStr];
     }];
    return result;
}



//////////////////////////////////////
+ (BOOL)isHoldCoinWithExistModel:(CoinModel *)model{
    __block BOOL    result = NO;
    FMDatabaseQueue *dataQueue = [BLDBManager getDBQueue];
    
    [dataQueue inDatabase:^(FMDatabase *db)
     {
         NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE coinValue = '%@' and walletId = '%@'", @"T_DB_HOLD_COIN", @(model.coinValue),BL_WalletId];
         FMResultSet *rs = [db executeQuery:sql];
         
         while ([rs next]) {
             result = YES;
         }
         
         [rs close];
     }];
    return result;
}

@end
