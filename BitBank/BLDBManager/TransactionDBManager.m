//
//  TransactionDBManager.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/23.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "TransactionDBManager.h"
#import "BLDBManager.h"
#import "FMResultSet.h"

@implementation TransactionDBManager

+ (BOOL)insertTransactionDBWithModel:(TranModel *)model coinType:(NSString*)coinType{
    FMDatabaseQueue *dataQueue = [BLDBManager getDBQueue];
    __block BOOL result = NO;
        
    [dataQueue inDatabase:^(FMDatabase *db)
     {
         result = [db executeUpdate:@"REPLACE INTO T_DB_TRANSACTION (walletId,coinType,uniqueId,txId,targetAddr,tranType,tranState,tranAmt,createTime,bak) VALUES  (?,?,?,?,?,?,?,?,?,?)",BL_WalletId,coinType,model.uniqueId,model.txId, model.targetAddr,model.tranType,model.tranState, model.tranAmt,model.createTime,model.bak];
         
         if (!result) {
             DDLogInfo(@"insert insertTransactionDBWithModel failed");
         }
     }];
    return result;
}


+ (NSMutableArray *)queryAllTransactionWithCoinType:(NSString*)coinType{
    __block NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    
    FMDatabaseQueue *dataQueue = [BLDBManager getDBQueue];
    
    [dataQueue inDatabase:^(FMDatabase *db)
     {
         NSString *findSql = [NSString stringWithFormat:@"SELECT * FROM %@ where walletId ='%@'and coinType ='%@' Order By uniqueId DESC", @"T_DB_TRANSACTION",BL_WalletId,coinType];
         FMResultSet *rs = [db executeQuery:findSql];
         
         while ([rs next]){
             TranModel *model = [[TranModel alloc]init];
             model.uniqueId = [rs stringForColumn:@"uniqueId"];
             model.txId = [rs stringForColumn:@"txId"];
             model.targetAddr = [rs stringForColumn:@"targetAddr"];
             model.tranType = [rs stringForColumn:@"tranType"];
             model.tranState = [rs stringForColumn:@"tranState"];
             model.tranAmt = [rs stringForColumn:@"tranAmt"];
             model.createTime = [rs stringForColumn:@"createTime"];
             model.bak = [rs stringForColumn:@"bak"];
             [resultArray addObject:model];
         }
         
         if (rs){
             [rs close];
         }
     }];
    
    return resultArray;
}

+ (BOOL)deleteAllTransaction{
    __block BOOL result = NO;
    FMDatabaseQueue* dataQueue = [BLDBManager getDBQueue];
    
    [dataQueue inDatabase:^(FMDatabase* db)
     {
         NSString* sqlStr = [NSString stringWithFormat:@"delete from %@ where walletId ='%@' ", @"T_DB_TRANSACTION",BL_WalletId];
         result = [db executeUpdate:sqlStr];
     }];
    return result;
}

@end
