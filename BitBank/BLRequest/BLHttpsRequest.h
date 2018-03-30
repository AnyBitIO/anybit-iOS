//
//  BLHttpsRequest.h
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/9.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLHttpsRequest : NSObject

+(void)basePostHttpsRequestWithBlock:(void(^)(NSDictionary *responseObject,NSString *rtnCode,NSString *errCode,NSString *errMsg, NSError * error))block paramDic:(NSDictionary*)paramDic path:(NSString*)path;

@end
