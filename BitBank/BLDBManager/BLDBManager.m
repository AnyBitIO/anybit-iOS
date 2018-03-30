//
//  BLDBManager.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/10.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "BLDBManager.h"
#import "FMDBMigrationManager.h"
#import "BLUnitsMethods.h"

static FMDatabaseQueue *dbQueue;

@implementation BLDBManager

+ (void)initCoreBizDBMigrationManagerSetting
{
    NSBundle *CoreBizBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"CoreBizDBMigrationManager" ofType:@"bundle"]];
    
    FMDBMigrationManager *manager = [FMDBMigrationManager managerWithDatabaseAtPath:[[BLUnitsMethods  userFilePath] stringByAppendingPathComponent:T_BIZ_DB_NAME]  migrationsBundle:CoreBizBundle];
    
    BOOL resultState = NO;
    NSError *error = nil;
    if (!manager.hasMigrationsTable)
    {
        resultState = [manager createMigrationsTable:&error];
    }
    
    resultState = [manager migrateDatabaseToVersion:UINT64_MAX progress:nil error:&error];//迁移函数
}

#pragma mark - 业务相关的数据库 -

+ (FMDatabaseQueue *)getDBQueue
{
    if (dbQueue) {
        return dbQueue;
    }
    
    @synchronized(self) {
        NSString *realPath = [[BLUnitsMethods  userFilePath] stringByAppendingPathComponent:T_BIZ_DB_NAME];
        dbQueue = [FMDatabaseQueue databaseQueueWithPath:realPath];
    }
    return dbQueue;
}

+ (void)closeDB
{
    if (dbQueue)
    {
        [dbQueue close];
    }
}


#pragma mark - common -

+ (void)initDBSettings
{
    // 重新初始化数据库，（更换用户后数据库路径会改变，需要重新初始化数据库操作队列）
    [BLDBManager closeDB];
    [BLDBManager reInitDBQueue];
    [BLDBManager initCoreBizDBMigrationManagerSetting];
}

+ (void)reInitDBQueue
{
    @synchronized(self) {
        NSString *realPath = [[BLUnitsMethods  userFilePath] stringByAppendingPathComponent:T_BIZ_DB_NAME];
        dbQueue = [FMDatabaseQueue databaseQueueWithPath:realPath];
    }
}

@end
