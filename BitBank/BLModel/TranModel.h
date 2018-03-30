//
//  TranModel.h
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/15.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TranModel : NSObject

@property(nonatomic,strong)NSString *uniqueId;
@property(nonatomic,strong)NSString *txId;
@property(nonatomic,strong)NSString *targetAddr;
@property(nonatomic,strong)NSString *tranType;
@property(nonatomic,strong)NSString *tranState;
@property(nonatomic,strong)NSString *tranAmt;
@property(nonatomic,strong)NSString *createTime;
@property(nonatomic,strong)NSString *bak;

@end
