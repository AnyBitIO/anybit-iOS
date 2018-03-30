//
//  BLWalletModel.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/1.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "BLWalletModel.h"

@implementation BLWalletModel

+(BLWalletModel *)shareInstance{
    static BLWalletModel *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

-(id)init{
    self = [super init];
    if (self){
        _walletId = @"";
    }
    return self;
}


@end
