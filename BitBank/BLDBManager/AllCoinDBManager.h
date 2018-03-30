//
//  AllCoinDBManager.h
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/10.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AllCoinDBManager : NSObject

+(NSMutableArray *)queryAllCoinInfo;

+(uint)queryCoinValueWithName:(NSString *)coinType;

@end
