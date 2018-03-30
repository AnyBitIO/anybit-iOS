//
//  BLAppDotNetAPIClient.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/9.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "BLAppDotNetAPIClient.h"

//static NSString * const YBAppDotNetAPIBaseURLString = @"http://192.168.1.145:8080/server/process";

@implementation BLAppDotNetAPIClient

+ (instancetype)sharedDefaultSessionClient
{
    static BLAppDotNetAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _sharedClient = [[BLAppDotNetAPIClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];
//        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        policy.allowInvalidCertificates = YES;//是否允许CA不信任的证书通过
        policy.validatesDomainName = NO;//是否验证主机名
        _sharedClient.securityPolicy = policy;
        
        _sharedClient.requestSerializer.timeoutInterval = 35;
        _sharedClient.requestSerializer = [AFJSONRequestSerializer serializer];
        _sharedClient.responseSerializer = [AFJSONResponseSerializer serializer];
        _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain",@"text/html",@"image/jpeg",@"video/mp4",@"application/xml", @"text/xml",@"application/x-plist", nil];

    });
    
    return _sharedClient;
}

@end
