//
//  BLDBManager.h
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/10.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"

#define T_BIZ_DB_NAME          @"T_BIZ_DB.db"  //数据库名称

@interface BLDBManager : NSObject

+ (FMDatabaseQueue *)getDBQueue;


+(void)initDBSettings;

@end
