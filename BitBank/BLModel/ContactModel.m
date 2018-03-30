//
//  ContactModel.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/8.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "ContactModel.h"

@implementation ContactModel

-(id)init{
    self = [super init];
    if (self){
        _coinType = @"";
        _nickName = @"";
        _address = @"";
    }
    return self;
}

@end
