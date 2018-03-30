//
//  BLHttpsRequest.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/9.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "BLHttpsRequest.h"
#import "BLAppDotNetAPIClient.h"
#import "CusMD5.h"
#import "BLNetwork.h"

@implementation BLHttpsRequest

+(void)basePostHttpsRequestWithBlock:(void(^)(NSDictionary *responseObject,NSString *rtnCode,NSString *errCode,NSString *errMsg, NSError * error))block paramDic:(NSDictionary*)paramDic path:(NSString*)path{
    
    if (![BLNetwork isNetworkAvailable]) {
        DDLogInfo(@"网络链接不可用");

        if (block) {
            NSDictionary* userInfo = @{ NSLocalizedDescriptionKey: Localized(@"request_netError")};
            NSError* error = [NSError errorWithDomain:@"" code:NSURLErrorNotConnectedToInternet userInfo:userInfo];

            block(@{},0,BL_HTTP_CODE_NOT_NET, Localized(@"request_netError"), error);
        }
        return;
    }
    
    NSDictionary *dic = [[self class] getSendDicWithParamDic:paramDic path:path];
    DDLogInfo(@"------------->>发送请求------------->>\n\n  dic = %@  \n url = %@", dic,BL_HTTP_SERVER);
    
    AFHTTPSessionManager* maneger =  [BLAppDotNetAPIClient sharedDefaultSessionClient];

    [maneger POST:BL_HTTP_SERVER parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *retCode = [NSString stringWithFormat:@"%@", [responseObject valueForKeyPath:BL_HTTP_CODE_RTN]];
        NSString *errCode = [NSString stringWithFormat:@"%@", [responseObject valueForKeyPath:BL_HTTP_CODE_ERR]];
        NSString *errMsg  = [NSString stringWithFormat:@"%@", [responseObject valueForKeyPath:BL_HTTP_MSG_ERR]];
        NSDictionary *returnDic = [NSMutableDictionary dictionaryWithDictionary:responseObject];
        
        DDLogInfo(@"---------->>收到网络返回---------->> \n\n retCode = %@  \n errCode = %@ \n errMsg = %@ \n responseObject = %@ ------------请求结束--------------\n\n", retCode,errCode, errMsg, responseObject);
        
        block(returnDic, retCode, errCode, errMsg, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        DDLogInfo(@"收到网络返回error :%@", error);
        if (block) {
            block(@{},0,BL_HTTP_CODE_NOT_SERVER,Localized(@"request_netError"), error);
        }
    }];
}

+(NSDictionary*)getSendDicWithParamDic:(NSDictionary*)paramDic path:(NSString*)path{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *language = [[NSUserDefaults standardUserDefaults]objectForKey:NDappLanguage];
    NSString *trancode = path;
    NSString *clienttype = @"iOS";
    NSString *walletid = BL_WalletId;
    NSString *random = @"lightwallet@locklinker.com";
    NSString *handshake = [[self class] handshake];
    NSString *imie = [[UIDevice currentDevice].identifierForVendor UUIDString];
    
    [dic setValue:@{@"version":version,@"language":language,
                    @"trancode":trancode,@"clienttype":clienttype,
                    @"walletid":walletid,@"random":random,
                    @"handshake":handshake,
                    @"imie":imie} forKey:@"header"];
    
    [dic setValue:paramDic forKey:@"body"];
    return dic;
}

+(NSString *)handshake{
    
    int num = (arc4random() % 100000);
    NSString *randomNumber = [NSString stringWithFormat:@"%.5d", num];
    NSString *md5ToString = [NSString stringWithFormat:@"lightwallet%@locklinker.com",randomNumber];
    NSString *md5String = [CusMD5 md5String:md5ToString];
    return md5String;
}

@end
