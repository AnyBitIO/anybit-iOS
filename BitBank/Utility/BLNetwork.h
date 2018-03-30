//
//  BLNetwork.h
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/22.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLNetwork : NSObject

+ (BLNetwork *)sharedInstance;
+ (BOOL)isNetworkAvailable;

@end
