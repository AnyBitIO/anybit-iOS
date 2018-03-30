//
//  BLNetwork.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/22.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "BLNetwork.h"
#import "YBReachability.h"

@implementation BLNetwork

+ (BLNetwork*)sharedInstance {
    static BLNetwork* sharedReach = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedReach = [[BLNetwork alloc] init];
    });
    return sharedReach;
}

#pragma mark
+ (BOOL)isNetworkAvailable
{
    YBReachability* internetReachability = [YBReachability reachabilityForInternetConnection];
    BOOL isinternetAvailable    = ([internetReachability currentReachabilityStatus] != NotReachable);
    
    if (isinternetAvailable == NO)
    {
        return isinternetAvailable;
    }
    
    YBReachability *hostReachability = [YBReachability reachabilityWithHostName:@"www.baidu.com"];
    BOOL ishostAvailable    = ([hostReachability currentReachabilityStatus] != NotReachable);
    if (ishostAvailable == NO)
    {
        return ishostAvailable;
    }
    return (isinternetAvailable && ishostAvailable);
}


- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

@end
