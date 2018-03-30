//
//  BLWalletModel.h
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/1.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLWalletModel : NSObject

@property(nonatomic,strong)NSString *walletId;

+(BLWalletModel *)shareInstance;

@end
