//
//  CoinModel.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/5.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "CoinModel.h"

@implementation CoinModel

-(id)init{
    self = [super init];
    if (self){
        _coinValue = 0;
        _coinType = @"";
        _isDefault = NO;
        _address = @"";
        
        _count = @"";
        _isBifurcate = NO;
        _isSelect = NO;
    }
    return self;
}

@end
