//
//  BLSignatureManager.h
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/7.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLSignatureManager : NSObject

+ (BOOL)verifyReturnedDataIsValidWithOriginalTransaction:(NSString *)originalString
                                                 sendDic:(NSDictionary*)sendDic
                                                coinType:(NSString *)coinType;

+ (NSString *)getSignatureDataWithOriginalTransaction:(NSString *)originalString
                                              inputs:(NSArray *)compareInputs
                                            coinType:(NSString *)coinType
                                              payPsd:(NSString*)payPsd;

@end
