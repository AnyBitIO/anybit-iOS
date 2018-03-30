//
//  CoinModel.h
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/5.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoinModel : NSObject

//数据库字段
@property(nonatomic,assign)int coinValue;
@property(nonatomic,strong)NSString *address;
@property(nonatomic,strong)NSString *coinType;
@property(nonatomic,assign)BOOL isDefault;//是否默认货币

//临时字段
@property(nonatomic,strong)NSString *count;
@property(nonatomic,assign)BOOL isBifurcate;//是否是分叉币
@property(nonatomic,assign)BOOL isSelect;//是否被选中


@end
