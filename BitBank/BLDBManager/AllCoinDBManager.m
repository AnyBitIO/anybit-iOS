//
//  AllCoinDBManager.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/10.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "AllCoinDBManager.h"
#import "FMDatabase.h"
#import "CoinModel.h"

@implementation AllCoinDBManager


+(NSString *)getLocaldbPath{
    NSString *path = [NSString stringWithFormat:@"%@/Coin.db", [[NSBundle mainBundle]bundlePath]];
    return path;
}

+(NSMutableArray *)queryAllCoinInfo{
    NSString *areaPath = [AllCoinDBManager getLocaldbPath];
    
    FMDatabase *dataBase = [FMDatabase databaseWithPath:areaPath];
    
    if ([dataBase open]) {
        
        FMResultSet *res = [dataBase executeQuery:@"select * from T_DB_Coin"];
        __block NSMutableArray  *resultArray = [[NSMutableArray alloc]init];
        
        while ([res next]) {
            CoinModel *model = [[CoinModel alloc]init];
            model.coinType = [res stringForColumn:@"coinType"];
            model.coinValue = [[res stringForColumn:@"coinValue"] intValue];

            [resultArray addObject:model];
        }
        
        [res close];
        [dataBase close];
        return resultArray;
    } else {
        DDLogInfo(@"数据库打开失败！");
        return nil;
    }
}

+(uint)queryCoinValueWithName:(NSString *)coinType{
    
    __block uint coinValue = 0;
    NSString *areaPath = [AllCoinDBManager getLocaldbPath];
    
    FMDatabase *dataBase = [FMDatabase databaseWithPath:areaPath];
    
    if ([dataBase open]) {
        
        FMResultSet *res = [dataBase executeQuery:[NSString stringWithFormat:@"SELECT coinValue FROM T_DB_Coin WHERE coinType = '%@'",coinType]];
        
        while ([res next]) {
            coinValue = [[res stringForColumn:@"coinValue"] intValue];
        }
        
        [res close];
        [dataBase close];
        return coinValue;
    }else{
        return 0;
    }
}

@end
