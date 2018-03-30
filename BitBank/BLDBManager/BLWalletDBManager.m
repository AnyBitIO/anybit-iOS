//
//  BLWalletDBManager.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/19.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "BLWalletDBManager.h"
#import "BLDBManager.h"
#import "FMResultSet.h"

@implementation BLWalletDBManager

+(BOOL)insertWalletDBWithWalletName:(NSString *)walletName
                          walletUrl:(NSString *)walletUrl
                           walletId:(NSString *)walletId
                      mnemonicWords:(NSString *)mnemonicWords
                            seedKey:(NSString *)seedKey
                           loginPsd:(NSString *)loginPsd
                             payPsd:(NSString *)payPsd
                  needLoginPassword:(BOOL)needLoginPassword
                          isDefault:(BOOL)isDefault{
    
    FMDatabaseQueue *dataQueue = [BLDBManager getDBQueue];
    __block BOOL result = NO;
    
    [dataQueue inDatabase:^(FMDatabase *db)
     {
         result = [db executeUpdate:@"REPLACE INTO T_DB_WALLET (walletName,walletUrl,walletId,mnemonicWords,seedKey,loginPsd,payPsd,needLoginPassword,isDefault) VALUES  (?,?,?,?,?,?,?,?,?)",walletName, walletUrl, walletId, mnemonicWords,seedKey, loginPsd,payPsd ,@(needLoginPassword),@(isDefault)];
         
         if (!result) {
             DDLogInfo(@"replace insertWalletDB failed");
         }
     }];
    
    return result;
}

+(NSMutableArray *)queryWalletDBData{
    __block NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    
    FMDatabaseQueue *dataQueue = [BLDBManager getDBQueue];
    
    [dataQueue inDatabase:^(FMDatabase *db)
     {
         NSString *findSql = [NSString stringWithFormat:@"SELECT * FROM T_DB_WALLET"];
         FMResultSet *rs = [db executeQuery:findSql];
         
         while ([rs next]){
             NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
             [dic setObject:[rs stringForColumn:@"walletId"] forKey:@"walletId"];
             [dic setObject:[rs stringForColumn:@"isDefault"] forKey:@"isDefault"];
             [resultArray addObject:dic];
         }
         
         if (rs){
             [rs close];
         }
     }];
    
    return resultArray;
}

+(NSString*)getWalletId{
    __block NSString *_walletId = @"";
    
    FMDatabaseQueue *dataQueue = [BLDBManager getDBQueue];
    
    [dataQueue inDatabase:^(FMDatabase *db)
     {
         NSString *findSql = [NSString stringWithFormat:@"SELECT * FROM T_DB_WALLET where isDefault ='%d'",YES];
         FMResultSet *rs = [db executeQuery:findSql];
         
         while ([rs next]){
             _walletId = [rs stringForColumn:@"walletId"];
         }
         
         if (rs){
             [rs close];
         }
     }];
    return _walletId;
}

+ (NSString*)getWalletName{
    __block NSString *_walletName = @"";
    
    FMDatabaseQueue *dataQueue = [BLDBManager getDBQueue];
    
    [dataQueue inDatabase:^(FMDatabase *db)
     {
         NSString *findSql = [NSString stringWithFormat:@"SELECT * FROM T_DB_WALLET where walletId ='%@'",BL_WalletId];
         FMResultSet *rs = [db executeQuery:findSql];
         
         while ([rs next]){
             _walletName = [rs stringForColumn:@"walletName"];
         }
         
         if (rs){
             [rs close];
         }
     }];
    return _walletName;
}

+ (BOOL)updateWalletName:(NSString*)name{
    __block BOOL    result = NO;
    FMDatabaseQueue *dataQueue = [BLDBManager getDBQueue];
    
    [dataQueue inDatabase:^(FMDatabase *db)
     {
         NSString *sql = [NSString stringWithFormat:@"UPDATE T_DB_WALLET SET walletName = '%@' WHERE walletId ='%@' ", name,BL_WalletId];
         FMResultSet *rs = [db executeQuery:sql];
         
         while ([rs next]) {
             result = YES;
         }
         
         [rs close];
     }];
    return result;
}

+ (BOOL)deleteOneWalletData{
    __block BOOL result = NO;
    FMDatabaseQueue* dataQueue = [BLDBManager getDBQueue];
    
    [dataQueue inDatabase:^(FMDatabase* db)
     {
         NSString* sqlStr = [NSString stringWithFormat:@"delete from %@ where walletId ='%@' ", @"T_DB_WALLET",BL_WalletId];
         result = [db executeUpdate:sqlStr];
     }];
    return result;
}


+(NSString*)getWalletMnemonicWords{
    __block NSString *_mnemonicWords = @"";
    
    FMDatabaseQueue *dataQueue = [BLDBManager getDBQueue];
    
    [dataQueue inDatabase:^(FMDatabase *db)
     {
         NSString *findSql = [NSString stringWithFormat:@"SELECT * FROM T_DB_WALLET where walletId ='%@'",BL_WalletId];
         FMResultSet *rs = [db executeQuery:findSql];
         
         while ([rs next]){
             _mnemonicWords = [rs stringForColumn:@"mnemonicWords"];
         }
         
         if (rs){
             [rs close];
         }
     }];
    return _mnemonicWords;
}

+ (BOOL)updateWalletMnemonicWords:(NSString*)mnemonicWords{
    __block BOOL    result = NO;
    FMDatabaseQueue *dataQueue = [BLDBManager getDBQueue];
    
    [dataQueue inDatabase:^(FMDatabase *db)
     {
         NSString *sql = [NSString stringWithFormat:@"UPDATE T_DB_WALLET SET mnemonicWords = '%@' WHERE walletId ='%@' ", mnemonicWords,BL_WalletId];
         FMResultSet *rs = [db executeQuery:sql];
         
         while ([rs next]) {
             result = YES;
         }
         
         [rs close];
     }];
    return result;
}

+(NSString*)getWalletSeedKey{
    __block NSString *_seedKey = @"";
    
    FMDatabaseQueue *dataQueue = [BLDBManager getDBQueue];
    
    [dataQueue inDatabase:^(FMDatabase *db)
     {
         NSString *findSql = [NSString stringWithFormat:@"SELECT * FROM T_DB_WALLET where walletId ='%@'",BL_WalletId];
         FMResultSet *rs = [db executeQuery:findSql];
         
         while ([rs next]){
             _seedKey = [rs stringForColumn:@"seedKey"];
         }
         
         if (rs){
             [rs close];
         }
     }];
    return _seedKey;
}

+ (BOOL)updateWalletSeedKey:(NSString*)seedKey{
    __block BOOL    result = NO;
    FMDatabaseQueue *dataQueue = [BLDBManager getDBQueue];
    
    [dataQueue inDatabase:^(FMDatabase *db)
     {
         NSString *sql = [NSString stringWithFormat:@"UPDATE T_DB_WALLET SET seedKey = '%@' WHERE walletId ='%@' ", seedKey,BL_WalletId];
         FMResultSet *rs = [db executeQuery:sql];
         
         while ([rs next]) {
             result = YES;
         }
         
         [rs close];
     }];
    return result;
}

+(NSString*)getWalletLoginPsd{
    __block NSString *_loginPsd = @"";
    
    FMDatabaseQueue *dataQueue = [BLDBManager getDBQueue];
    
    [dataQueue inDatabase:^(FMDatabase *db)
     {
         NSString *findSql = [NSString stringWithFormat:@"SELECT * FROM T_DB_WALLET where walletId ='%@'",BL_WalletId];
         FMResultSet *rs = [db executeQuery:findSql];
         
         while ([rs next]){
             _loginPsd = [rs stringForColumn:@"loginPsd"];
         }
         
         if (rs){
             [rs close];
         }
     }];
    return _loginPsd;
}

+ (BOOL)updateWalletLoginPsd:(NSString*)loginPsd{
    __block BOOL    result = NO;
    FMDatabaseQueue *dataQueue = [BLDBManager getDBQueue];
    
    [dataQueue inDatabase:^(FMDatabase *db)
     {
         NSString *sql = [NSString stringWithFormat:@"UPDATE T_DB_WALLET SET loginPsd = '%@' WHERE walletId ='%@' ", loginPsd,BL_WalletId];
         FMResultSet *rs = [db executeQuery:sql];
         
         while ([rs next]) {
             result = YES;
         }
         
         [rs close];
     }];
    return result;
}


+(NSString*)getWalletPayPsd{
    __block NSString *_payPsd = @"";
    
    FMDatabaseQueue *dataQueue = [BLDBManager getDBQueue];
    
    [dataQueue inDatabase:^(FMDatabase *db)
     {
         NSString *findSql = [NSString stringWithFormat:@"SELECT * FROM T_DB_WALLET where walletId ='%@'",BL_WalletId];
         FMResultSet *rs = [db executeQuery:findSql];
         
         while ([rs next]){
             _payPsd = [rs stringForColumn:@"payPsd"];
         }
         
         if (rs){
             [rs close];
         }
     }];
    return _payPsd;
}

+ (BOOL)updateWalletPayPsd:(NSString*)payPsd{
    __block BOOL    result = NO;
    FMDatabaseQueue *dataQueue = [BLDBManager getDBQueue];
    
    [dataQueue inDatabase:^(FMDatabase *db)
     {
         NSString *sql = [NSString stringWithFormat:@"UPDATE T_DB_WALLET SET payPsd = '%@' WHERE walletId ='%@' ", payPsd,BL_WalletId];
         FMResultSet *rs = [db executeQuery:sql];
         
         while ([rs next]) {
             result = YES;
         }
         
         [rs close];
     }];
    return result;
}

+(BOOL)getWalletNeedLoginPassword{
    __block BOOL _needLoginPassword = NO;
    
    FMDatabaseQueue *dataQueue = [BLDBManager getDBQueue];
    
    [dataQueue inDatabase:^(FMDatabase *db)
     {
         NSString *findSql = [NSString stringWithFormat:@"SELECT * FROM T_DB_WALLET where walletId ='%@'",BL_WalletId];
         FMResultSet *rs = [db executeQuery:findSql];
         
         while ([rs next]){
             _needLoginPassword = [[rs stringForColumn:@"needLoginPassword"] boolValue];
         }
         
         if (rs){
             [rs close];
         }
     }];
    return _needLoginPassword;
}

+ (BOOL)updateWalletNeedLoginPassword:(BOOL)isNeedLoginPassword{
    __block BOOL    result = NO;
    FMDatabaseQueue *dataQueue = [BLDBManager getDBQueue];
    
    [dataQueue inDatabase:^(FMDatabase *db)
     {
         NSString *sql = [NSString stringWithFormat:@"UPDATE T_DB_WALLET SET needLoginPassword = '%d' WHERE walletId ='%@' ", isNeedLoginPassword,BL_WalletId];
         FMResultSet *rs = [db executeQuery:sql];
         
         while ([rs next]) {
             result = YES;
         }
         
         [rs close];
     }];
    return result;
}


+ (BOOL)updateAllWalletIsDefaultNo{
    __block BOOL    result = NO;
    FMDatabaseQueue *dataQueue = [BLDBManager getDBQueue];
    
    [dataQueue inDatabase:^(FMDatabase *db)
     {
         NSString *sql = [NSString stringWithFormat:@"UPDATE T_DB_WALLET SET isDefault = '0'"];
         FMResultSet *rs = [db executeQuery:sql];
         
         while ([rs next]) {
             result = YES;
         }
         
         [rs close];
     }];
    return result;
}

+ (BOOL)updateOneWalletIsDefault:(BOOL)isDefault{
    __block BOOL    result = NO;
    FMDatabaseQueue *dataQueue = [BLDBManager getDBQueue];
    
    [dataQueue inDatabase:^(FMDatabase *db)
     {
         NSString *sql = [NSString stringWithFormat:@"UPDATE T_DB_WALLET SET isDefault = '%d' WHERE walletId ='%@'",isDefault,BL_WalletId];
         FMResultSet *rs = [db executeQuery:sql];
         
         while ([rs next]) {
             result = YES;
         }
         
         [rs close];
     }];
    return result;
}

+ (BOOL)queryWalletNameIsTakenWithName:(NSString*)name{
    __block BOOL    result = NO;
    FMDatabaseQueue *dataQueue = [BLDBManager getDBQueue];
    
    [dataQueue inDatabase:^(FMDatabase *db)
     {
         NSString *findSql = [NSString stringWithFormat:@"SELECT * FROM T_DB_WALLET where walletName ='%@'",name];
         FMResultSet *rs = [db executeQuery:findSql];
         
         while ([rs next]){
             result = YES;
             break;
         }
         
         if (rs){
             [rs close];
         }
     }];
    return result;
}

@end
