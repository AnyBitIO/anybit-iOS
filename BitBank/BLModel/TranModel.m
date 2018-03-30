//
//  TranModel.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/15.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "TranModel.h"

@implementation TranModel

-(id)init{
    self = [super init];
    if (self){
        _uniqueId = @"";
        _txId = @"";
        _targetAddr = @"";
        _tranType = @"";
        _tranState = @"";
        _tranAmt = @"";
        _createTime = @"";
        _bak = @"";
    }
    return self;
}

@end
