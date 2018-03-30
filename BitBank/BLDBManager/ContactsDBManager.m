//
//  ContactsDBManager.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/10.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "ContactsDBManager.h"
#import "BLDBManager.h"
#import "FMResultSet.h"

@implementation ContactsDBManager

+(BOOL)insertContactsDBWithModel:(ContactModel *)model{
    FMDatabaseQueue *dataQueue = [BLDBManager getDBQueue];
    __block BOOL result = NO;
    
    BOOL isExist = [self istContactsWithExistModel:model];
    
    if (!isExist) {
        [dataQueue inDatabase:^(FMDatabase *db)
         {
             result = [db executeUpdate:@"INSERT INTO T_DB_CONTACTS (walletId,nickName,coinType,address) VALUES  (?,?,?,?)",BL_WalletId,model.nickName, model.coinType,model.address];
             
             if (!result) {
                 DDLogInfo(@"insert insertContactsDB failed");
             }
         }];
    }
    return result;
}

+(NSMutableArray *)queryAllContactsDB{
    __block NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    
    FMDatabaseQueue *dataQueue = [BLDBManager getDBQueue];
    
    [dataQueue inDatabase:^(FMDatabase *db)
     {
         NSString *findSql = [NSString stringWithFormat:@"SELECT * FROM %@ where walletId ='%@'", @"T_DB_CONTACTS",BL_WalletId];
         FMResultSet *rs = [db executeQuery:findSql];
         
         while ([rs next]){
             ContactModel *model = [[ContactModel alloc]init];
             model.nickName = [rs stringForColumn:@"nickName"];
             model.coinType = [rs stringForColumn:@"coinType"];
             model.address = [rs stringForColumn:@"address"];
             [resultArray addObject:model];
         }
         
         if (rs){
             [rs close];
         }
     }];
    
    return resultArray;
}

+ (BOOL)deleteContactsDBWithModel:(ContactModel *)model{
    
    __block BOOL result = NO;
    FMDatabaseQueue* dataQueue = [BLDBManager getDBQueue];
    
    [dataQueue inDatabase:^(FMDatabase* db)
     {
         NSString* sqlStr = [NSString stringWithFormat:@"delete from %@ WHERE address = '%@' AND coinType ='%@' AND walletId ='%@'", @"T_DB_CONTACTS", model.address,model.coinType,BL_WalletId];
         result = [db executeUpdate:sqlStr];
     }];
    return result;
}

+ (BOOL)deleteAllContacts{
    __block BOOL result = NO;
    FMDatabaseQueue* dataQueue = [BLDBManager getDBQueue];
    
    [dataQueue inDatabase:^(FMDatabase* db)
     {
         NSString* sqlStr = [NSString stringWithFormat:@"delete from %@ where walletId ='%@' ", @"T_DB_CONTACTS",BL_WalletId];
         result = [db executeUpdate:sqlStr];
     }];
    return result;
}


//////////////////////////////////////
+ (BOOL)istContactsWithExistModel:(ContactModel *)model{
    __block BOOL    result = NO;
    FMDatabaseQueue *dataQueue = [BLDBManager getDBQueue];
    
    [dataQueue inDatabase:^(FMDatabase *db)
     {
         NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE address = '%@' AND coinType ='%@' AND walletId ='%@'", @"T_DB_CONTACTS", model.address,model.coinType,BL_WalletId];
         FMResultSet *rs = [db executeQuery:sql];
         
         while ([rs next]) {
             result = YES;
         }
         
         [rs close];
     }];
    return result;
}

@end
