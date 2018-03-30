//
//  BLAppDotNetAPIClient.h
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/9.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface BLAppDotNetAPIClient : AFHTTPSessionManager

+ (instancetype)sharedDefaultSessionClient;

@end
