//
//  BLSignatureManager.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/7.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "BLSignatureManager.h"
#import "BLKeyManager.h"
#import "secp256k1.h"
#import "NSString+Base58.h"
#import "NSData+Hash.h"
#import "NYMnemonic.h"

@implementation BLSignatureManager

/**
 *          第一项：解析原始交易  返回对象（dic）
 */
+(NSDictionary *)parseOriginalTransaction:(NSString *)originalString{
    
    NSMutableDictionary *retunDic = [[NSMutableDictionary alloc]init];
    
    //转为byte数组
    NSMutableArray *Bytes = [NSMutableArray arrayWithArray:[self getBytesWithString:originalString]];
    
    //原始交易的版本:前4个字节--->反转--->int值
    NSArray *versionArray = [Bytes subarrayWithRange:NSMakeRange(0, 4)];
    NSArray *reversedVersionArray = [[versionArray reverseObjectEnumerator] allObjects];
    NSUInteger version = [self getIntegerWith:reversedVersionArray];
    [retunDic setObject:[NSString stringWithFormat:@"%lu",(unsigned long)version] forKey:@"version"];
    [Bytes removeObjectsInRange:NSMakeRange(0, 4)];
    
    //inputs的个数 直接取值
    NSUInteger inputsCount = [[Bytes objectAtIndex:0] integerValue];
    [retunDic setObject:[NSString stringWithFormat:@"%lu",(unsigned long)inputsCount] forKey:@"inputCount"];
    [Bytes removeObjectsInRange:NSMakeRange(0, 1)];
    
    // 根据inputsCount  解析inputs（每一个input长度41）
    NSMutableArray *inputsArray = [[NSMutableArray alloc]init];
    for (int i=0; i<inputsCount; i++) {
        NSMutableDictionary *inputDic = [[NSMutableDictionary alloc]init];
        [inputDic setObject:@"" forKey:@"dataSize"];
        [inputDic setObject:@"" forKey:@"script"];
        
        //32位为inputs的hash 先反转--->hex字符串
        NSString *hashString = @"";
        NSArray *hashArray = [Bytes subarrayWithRange:NSMakeRange(0, 32)];
        NSArray *reversedHashArray = [[hashArray reverseObjectEnumerator] allObjects];
        for (int i=0; i<32; i++) {
            NSString *intIndex = [reversedHashArray objectAtIndex:i];
            NSString *hexStr = [self getHexByDecimal:[intIndex integerValue]];
            hashString = [hashString stringByAppendingString:hexStr];
        }
        [inputDic setObject:hashString forKey:@"txHash"];
        [Bytes removeObjectsInRange:NSMakeRange(0, 32)];
        
        //4位为index索引值，先反转--->int值
        NSArray *indexArray = [Bytes subarrayWithRange:NSMakeRange(0, 4)];
        NSArray *reversedIndexArray = [[indexArray reverseObjectEnumerator] allObjects];
        NSUInteger index = [self getIntegerWith:reversedIndexArray];
        [inputDic setObject:[NSString stringWithFormat:@"%lu",(unsigned long)index] forKey:@"txIndex"];
        [Bytes removeObjectsInRange:NSMakeRange(0, 4)];
        
        //ScriptSize整型，根据ScriptSize获取后面脚本的长度
        NSUInteger scriptSize = [[Bytes objectAtIndex:0] integerValue];
        [inputDic setObject:[NSString stringWithFormat:@"%lu",(unsigned long)scriptSize] forKey:@"scriptSize"];
        [Bytes removeObjectsInRange:NSMakeRange(0, 1)];
        
        //4位为Sequence，先反转再--->int类型
        NSArray *sequenceArray = [Bytes subarrayWithRange:NSMakeRange(0, 4)];
        NSArray *reversedSequenceArray = [[sequenceArray reverseObjectEnumerator] allObjects];
        NSUInteger sequence = [self getIntegerWith:reversedSequenceArray];
        [inputDic setObject:[NSString stringWithFormat:@"%lu",(unsigned long)sequence] forKey:@"sequence"];
        [Bytes removeObjectsInRange:NSMakeRange(0, 4)];
        
        [inputsArray addObject:inputDic];
    }
    [retunDic setObject:inputsArray forKey:@"inputs"];
    
    //outputs大小
    NSUInteger outputsCount = [[Bytes objectAtIndex:0] integerValue];
    [retunDic setObject:[NSString stringWithFormat:@"%lu",(unsigned long)outputsCount] forKey:@"outputCount"];
    [Bytes removeObjectsInRange:NSMakeRange(0, 1)];

    // 根据outputsCount  解析outputs（
    NSMutableArray *outsArray = [[NSMutableArray alloc]init];
    for (int i=0; i<outputsCount; i++) {
        NSMutableDictionary *outDic = [[NSMutableDictionary alloc]init];
        [outDic setObject:@"" forKey:@"dataSize"];
        
        //8位为第一个outputs金额，先反转--->long类型
        NSArray *amountArray = [Bytes subarrayWithRange:NSMakeRange(0, 8)];
        NSArray *reversedAmountArray = [[amountArray reverseObjectEnumerator] allObjects];
        NSUInteger amount = [self getIntegerWith:reversedAmountArray];
        [outDic setObject:[NSString stringWithFormat:@"%lu",(unsigned long)amount] forKey:@"amount"];
        [Bytes removeObjectsInRange:NSMakeRange(0, 8)];
        
        //varScriptSize大小
        NSUInteger scriptSize = [[Bytes objectAtIndex:0] integerValue];
        [outDic setObject:[NSString stringWithFormat:@"%lu",(unsigned long)scriptSize] forKey:@"scriptSize"];
        [Bytes removeObjectsInRange:NSMakeRange(0, 1)];
        
        //varScriptSize位为Script内容，装成hex
        NSString *scriptString = @"";
        NSArray *scriptArray = [Bytes subarrayWithRange:NSMakeRange(0, scriptSize)];
        for (int i=0; i<scriptSize; i++) {
            NSString *intIndex = [scriptArray objectAtIndex:i];
            NSString *hexStr = [self getHexByDecimal:[intIndex integerValue]];
            scriptString = [scriptString stringByAppendingString:hexStr];
        }
        [outDic setObject:scriptString forKey:@"script"];
        [Bytes removeObjectsInRange:NSMakeRange(0, scriptSize)];
        
        [outsArray addObject:outDic];
        
    }
    [retunDic setObject:outsArray forKey:@"outputs"];
    
    //4位为LockTime，先反转--->long类型
    NSArray *lockTimeArray = [Bytes subarrayWithRange:NSMakeRange(0, 4)];
    NSArray *reversedLockTimeArray = [[lockTimeArray reverseObjectEnumerator] allObjects];
    NSUInteger lockTime = [self getIntegerWith:reversedLockTimeArray];
    [retunDic setObject:[NSString stringWithFormat:@"%lu",(unsigned long)lockTime] forKey:@"lockTime"];
    
    DDLogInfo(@"解析原始交易数据dic:%@",retunDic);
    
    return  retunDic;
}


/**
 *          第二项：原始交易序列化  返回对象（string）
 */

+ (NSString *)getOriginalTransactionSerializationwithDic:(NSDictionary*)dic
                                              isHashType:(BOOL)isHashType
                                                coinType:(NSString *)coinType{
    //version+inputSize+inputs的序列化+outputSize+Outputs的序列化+LockTime的序列化+hashType的hex字符串
    NSString *returnString = @"";
    NSString *returnInputsString = @"";
    NSString *returnOutputsString = @"";
    
    //1、version  原始交易里的version转为4个字节数组->反转->hex
    NSUInteger version = [[dic objectForKey:@"version"] integerValue];
    NSString *version_serialization = [self getEndHexStringWithValue:version byteCount:4];
    returnString = [returnString stringByAppendingString:version_serialization];
    
    //2、inputsSize   (使用数组长度序列化)inputs数组大小转为一个字节，再hex
    NSUInteger inputCount = [[dic objectForKey:@"inputCount"] integerValue];
    NSArray *inputsSizeArray = [self getArrayLengthSerializationWithValue:inputCount];
    NSString *inputsCount_serialization = @"";
    for (int i=0; i<inputsSizeArray.count; i++) {
        NSString *intIndex = [inputsSizeArray objectAtIndex:i];
        NSString *hexStr = [self getHexByDecimal:[intIndex integerValue]];
        inputsCount_serialization = [inputsCount_serialization stringByAppendingString:hexStr];
    }
    returnString = [returnString stringByAppendingString:inputsCount_serialization];
    
    /*
     *3、inputs的序列化
     txHash转为32字节数组->反转->hex(结果为：b5c374de0091c2408daa9e693c4ff8d74f9047aeb52e04b2301d6b8167b3ad89)
     + index转为4个字节数组->反转->hex    (结果为：00000000)
     +scriptSize=script的长度/2 ，再使用数组长度序列化 ->hex   (结果为：19)
     +script->字节数组->hex(结果为：76a914dd7f5b96a40d3a63714b5c58be515a631ca2225688ac)
     +sequence->4个字节数组->反转->hex  (结果：ffffffff)
     
     returnInputsString = 交易 Hash+ 交易 Index+ Script Size+ Script+ Sequence
     */
    NSArray *inputsArray = [dic objectForKey:@"inputs"];
    for (int i=0; i<inputCount; i++) {
        NSDictionary *tempDic = [inputsArray objectAtIndex:i];
        
        NSString *txHash_serialization = @"";
        NSArray *hashBytes = [self getBytesWithString:[tempDic objectForKey:@"txHash"]];
        NSArray *reversedHashArray = [[hashBytes reverseObjectEnumerator] allObjects];
        for (int i=0; i<32; i++) {
            NSString *intIndex = [reversedHashArray objectAtIndex:i];
            NSString *hexStr = [self getHexByDecimal:[intIndex integerValue]];
            txHash_serialization = [txHash_serialization stringByAppendingString:hexStr];
        }
        returnInputsString = [returnInputsString stringByAppendingString:txHash_serialization];
        
        NSUInteger index = [[tempDic objectForKey:@"txIndex"] integerValue];
        NSString *index_serialization = [self getEndHexStringWithValue:index byteCount:4];
        returnInputsString = [returnInputsString stringByAppendingString:index_serialization];
        
        
        NSString *tempScrip = [tempDic objectForKey:@"script"];
        NSArray *scriptSizeArray = [self getArrayLengthSerializationWithValue:[tempScrip length]/2];
        NSString *scriptSize_serialization = @"";
        for (int i=0; i<scriptSizeArray.count; i++) {
            NSString *intIndex = [scriptSizeArray objectAtIndex:i];
            NSString *hexStr = [self getHexByDecimal:[intIndex integerValue]];
            scriptSize_serialization = [scriptSize_serialization stringByAppendingString:hexStr];
        }
        returnInputsString = [returnInputsString stringByAppendingString:scriptSize_serialization];
        
        //script->字节数组->hex(结果为：76a914dd7f5b96a40d3a63714b5c58be515a631ca2225688ac)
        NSString *script_serialization = @"";
        NSArray *scripBytes = [self getBytesWithString:tempScrip];
        for (int i=0; i<scripBytes.count; i++) {
            NSString *intIndex = [scripBytes objectAtIndex:i];
            NSString *hexStr = [self getHexByDecimal:[intIndex integerValue]];
            script_serialization = [script_serialization stringByAppendingString:hexStr];
        }
        returnInputsString = [returnInputsString stringByAppendingString:script_serialization];
        
        
        NSUInteger sequence = [[tempDic objectForKey:@"sequence"] integerValue];
        NSString *sequence_serialization = [self getEndHexStringWithValue:sequence byteCount:4];
        returnInputsString = [returnInputsString stringByAppendingString:sequence_serialization];
    }
    returnString = [returnString stringByAppendingString:returnInputsString];
    
    
    //4、outputSize序列化(使用数组长度序列化) 数组大小转为字节数组，再hex，（结果为：02）
    NSUInteger outputCount = [[dic objectForKey:@"outputCount"] integerValue];
    NSArray *outputsSizeArray = [self getArrayLengthSerializationWithValue:outputCount];
    NSString *outputsSize_serialization = @"";
    for (int i=0; i<outputsSizeArray.count; i++) {
        NSString *intIndex = [outputsSizeArray objectAtIndex:i];
        NSString *hexStr = [self getHexByDecimal:[intIndex integerValue]];
        outputsSize_serialization = [outputsSize_serialization stringByAppendingString:hexStr];
    }
    returnString = [returnString stringByAppendingString:outputsSize_serialization];
    
    
    /***
     *5、outputs的序列化
     金额转为8个字节数组长度，反转，hex (结果：b270550500000000)
     +scriptSize=script长度/2，再使用数组长度序列化，->hex (结果为：19)
     +script->字节数组->hex (结果为：76a914dd7f5b96a40d3a63714b5c58be515a631ca2225688ac)
     
     returnOutputsString = Amount+ Script Size+ Script
     ***/
    
    NSArray *outsArray = [dic objectForKey:@"outputs"];
    for (int i=0; i<outputCount; i++) {
        NSDictionary *tempDic = [outsArray objectAtIndex:i];
        
        NSUInteger amount = [[tempDic objectForKey:@"amount"] integerValue];
        NSString *amount_serialization = [self getEndHexStringWithValue:amount byteCount:8];
        returnOutputsString = [returnOutputsString stringByAppendingString:amount_serialization];
        
        NSString *tempScrip = [tempDic objectForKey:@"script"];
        NSArray *scriptSizeArray = [self getArrayLengthSerializationWithValue:[tempScrip length]/2];
        NSString *scriptSize_serialization = @"";
        for (int i=0; i<scriptSizeArray.count; i++) {
            NSString *intIndex = [scriptSizeArray objectAtIndex:i];
            NSString *hexStr = [self getHexByDecimal:[intIndex integerValue]];
            scriptSize_serialization = [scriptSize_serialization stringByAppendingString:hexStr];
        }
        returnOutputsString = [returnOutputsString stringByAppendingString:scriptSize_serialization];
        
        NSString *script_serialization = @"";
        NSArray *scripBytes = [self getBytesWithString:tempScrip];
        for (int i=0; i<scripBytes.count; i++) {
            NSString *intIndex = [scripBytes objectAtIndex:i];
            NSString *hexStr = [self getHexByDecimal:[intIndex integerValue]];
            script_serialization = [script_serialization stringByAppendingString:hexStr];
        }
        returnOutputsString = [returnOutputsString stringByAppendingString:script_serialization];
    }
    returnString = [returnString stringByAppendingString:returnOutputsString];
    
    //6、lockTime序列化lockTime->4个字节数组->反转->hex   (结果为：00000000)
    NSUInteger lockTime = [[dic objectForKey:@"lockTime"] integerValue];
    NSString *lockTime_serialization = [self getEndHexStringWithValue:lockTime byteCount:4];
    returnString = [returnString stringByAppendingString:lockTime_serialization];
    

    if (isHashType) {
        if ([coinType isEqualToString:@"BTC"]) {
            NSString *hashType =  [self getEndHexStringWithValue:1 byteCount:4];
            returnString = [returnString stringByAppendingString:hashType];
        }else if ([coinType isEqualToString:@"UBTC"]){
            returnString = [returnString stringByAppendingString:@"09000000027562"];
        }
    }

    DDLogInfo(@"原始交易序列化string:%@",returnString);
    return returnString;
}


/**
 *          第三项：签名  返回对象（dic）
 */
+(NSString *)getSecp256k1WithString:(NSString *)toBeSignString priKey:(NSString*)priKey{
    
    //原始交易序列化结果（上面一步计算的结果）进行两次SHA-256计算，再转为hex字符串；用私钥对原始交易进行secp256k1签名；
    NSData *tempData = [self dataFromHexString:toBeSignString];
    NSData *hashData = tempData.SHA256_2;
    NSString *sigeHashString = [[NSString hexWithData:hashData] lowercaseString];
    
    
    secp256k1_context *context = secp256k1_context_create((SECP256K1_CONTEXT_VERIFY | SECP256K1_CONTEXT_SIGN));
    secp256k1_ecdsa_signature signature;
    NSData *signData = [sigeHashString hexToData];
    const unsigned char *signDataBuffer = (const unsigned char *)[signData bytes];

    NSData *prikeyData = [priKey base58ToData];
    NSData *secretData = [prikeyData subdataWithRange:NSMakeRange(1, 32)];
    const unsigned char *secretDataBuffer = (const unsigned char *)[secretData bytes];
    
    secp256k1_ecdsa_sign(context, &signature, signDataBuffer, secretDataBuffer, secp256k1_nonce_function_rfc6979, NULL);
    
    secp256k1_ecdsa_signature_der result;
    size_t der_size = 72;
    secp256k1_ecdsa_signature_serialize_der(context, (unsigned char *)&result,&der_size, &signature);
    
    NSData *endData = [NSData dataWithBytes:&result length:der_size];
    NSString *endString = [endData ny_hexString];
    DDLogInfo(@"用私钥对原始交易进行secp256k1签名:%@",endString);
    return endString;
}

/**
 *          第四项：在原始交易中插入script脚本
 */
+(NSString *)getInputScriptWithString:(NSString *)secp256k1String
                               pubKey:(NSString*)pubKey
                             coinType:(NSString *)coinType{
    
    //script=（签名结果长度+1）+签名+“01”+地址长度+公钥；
    NSArray *stringBytes = [self getBytesWithString:secp256k1String];
    NSArray *writeVariableArray = [self writeVariableStackIntWithValue:[stringBytes count]+1];
    NSString *writeVariableScript = @"";
    for (int i=0; i<writeVariableArray.count; i++) {
        NSString *intIndex = [writeVariableArray objectAtIndex:i];
        NSString *hexStr = [self getHexByDecimal:[intIndex integerValue]];
        writeVariableScript = [writeVariableScript stringByAppendingString:hexStr];
    }
    
    NSArray *pubKeyBytes = [self getBytesWithString:pubKey];
    NSArray *pubKeyArray = [self writeVariableStackIntWithValue:[pubKeyBytes count]];
    NSString *script = @"";
    for (int i=0; i<pubKeyArray.count; i++) {
        NSString *intIndex = [pubKeyArray objectAtIndex:i];
        NSString *hexStr = [self getHexByDecimal:[intIndex integerValue]];
        script = [script stringByAppendingString:hexStr];
    }
    
    NSString *endScript = @"";
    if ([coinType isEqualToString:@"BTC"]) {
        endScript = [NSString stringWithFormat:@"%@%@%@%@%@",writeVariableScript,secp256k1String,@"01",script,pubKey];
    }else if ([coinType isEqualToString:@"UBTC"]){
        endScript = [NSString stringWithFormat:@"%@%@%@%@%@",writeVariableScript,secp256k1String,@"09",script,pubKey];
    }
    return endScript;
}



+ (NSString *)getSignatureDataWithOriginalTransaction:(NSString *)originalString
                                               inputs:(NSArray *)compareInputs
                                             coinType:(NSString *)coinType
                                               payPsd:(NSString*)payPsd{
    if ([coinType isEqualToString:@"UBTC"]) {
        NSString *priKey = [BLKeyManager getPrivateKeyWithCoinType:coinType payPsd:payPsd];
        NSString *pubKey = [BLKeyManager getPublicKeyWithCoinType:coinType payPsd:payPsd];
        
        //解析原始数据后，parseDic的inputs里面所有的scrip初始为空
        NSDictionary *parseDic = [self parseOriginalTransaction:originalString];
        
        //先得到与parseDic一样的tempDic，与compareInputs进行对比，为tempDic里inputs里的scrip赋值，计算签名结果，把结果暂时储存于compareInputs
        NSUInteger inputCount = [[parseDic objectForKey:@"inputCount"] integerValue];
        for (int i=0;i<inputCount;i++ ) {
            
            NSDictionary *tempDic = [NSDictionary dictionaryWithDictionary:parseDic];
            NSArray *inputsArray = [tempDic objectForKey:@"inputs"];
            NSDictionary *iDic = [inputsArray objectAtIndex:i];
            
            for (int j=0;j<compareInputs.count;j++) {
                
                NSDictionary *jDic = [compareInputs objectAtIndex:j];
                if ([[iDic objectForKey:@"txHash"] isEqualToString:[jDic objectForKey:@"txid"]] &&
                    [[iDic objectForKey:@"txIndex"] isEqualToString:[jDic objectForKey:@"vout"]]) {
                    
                    [iDic setValue:[jDic objectForKey:@"scriptPubKey"] forKey:@"script"];
                    NSString *serializationString = [self getOriginalTransactionSerializationwithDic:tempDic isHashType:YES coinType:coinType];
                    NSString *secp256k1String = [self getSecp256k1WithString:serializationString priKey:priKey];
                    NSString *newScrip = [self getInputScriptWithString:secp256k1String pubKey:pubKey coinType:coinType];
                    [iDic setValue:@"" forKey:@"script"];
                    [jDic setValue:newScrip forKey:@"scriptPubKey"];
                }
            }
        }
        
        
        //再与compareInputs进行对比，为parseDic里inputs里的scrip赋值，得到最终签名结果
        for (int i=0;i<inputCount;i++ ) {
            NSArray *inputsArray = [parseDic objectForKey:@"inputs"];
            NSDictionary *iDic = [inputsArray objectAtIndex:i];
            
            for (int j=0;j<compareInputs.count;j++) {
                
                NSDictionary *jDic = [compareInputs objectAtIndex:i];
                if ([[iDic objectForKey:@"txHash"] isEqualToString:[jDic objectForKey:@"txid"]] &&
                    [[iDic objectForKey:@"txIndex"] isEqualToString:[jDic objectForKey:@"vout"]]) {
                    
                    [iDic setValue:[jDic objectForKey:@"scriptPubKey"] forKey:@"script"];
                }
            }
        }
        
        
        NSString *lastSignatureData = [self getOriginalTransactionSerializationwithDic:parseDic isHashType:NO coinType:coinType];
        DDLogInfo(@"最终签名的结果:%@",lastSignatureData);
        return lastSignatureData;
    }else{
        return @"";
    }
    
}



+ (BOOL)verifyReturnedDataIsValidWithOriginalTransaction:(NSString *)originalString
                                                 sendDic:(NSDictionary*)sendDic
                                                coinType:(NSString *)coinType{
    if ([coinType isEqualToString:@"UBTC"]) {
        BOOL _verifySuccess = YES;
        NSString *fromAddr = [sendDic objectForKey:@"fromAddr"];
        NSString *toAddr = [sendDic objectForKey:@"toAddr"];
        NSDecimalNumber *tranNumber = [NSDecimalNumber decimalNumberWithString:[sendDic objectForKey:@"tranAmt"]];
        NSDecimalNumber *number = [NSDecimalNumber decimalNumberWithString:@"100000000"];
        NSString *tranAmt = [NSString stringWithFormat:@"%@",[tranNumber decimalNumberByMultiplyingBy:number]];
        
        NSDictionary *parseDic = [self parseOriginalTransaction:originalString];
        NSArray *outputs = [parseDic objectForKey:@"outputs"];
        for (NSDictionary *tempDic in outputs) {
            NSString *script = [tempDic objectForKey:@"script"];
            NSString *address = [NSString addressWithScript:[script ny_dataFromHexString]];;
            if (!([address isEqualToString:fromAddr]||[address isEqualToString:toAddr])) {
                _verifySuccess= NO;
                break;
            }
            if ([address isEqualToString:toAddr]) {
                NSString *amount = [tempDic objectForKey:@"amount"];
                if (![amount isEqualToString:tranAmt]) {
                    _verifySuccess= NO;
                    break;
                }
            }
        }
        return _verifySuccess;
    }else{
        return NO;
    }
}











///////////////////////////////////////////~~~~~~~~~~~下面为私有方法~~~~~~~~~~~//////////////////////////////////////////////////
#pragma mark- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~下面为私有方法~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#pragma mark- 字符串--->byte数组(每2位转为十进制)
+ (NSArray*)getBytesWithString:(NSString*)str{
    NSMutableArray *Bytes = [[NSMutableArray alloc]init];
    
    NSInteger strLength = [str length];
    if (strLength%2 == 0){
        for (int i=0; i<strLength/2; i++){
            NSString *tempStr = [str substringWithRange:NSMakeRange(i*2,2)];
            NSString *tenStr = [NSString stringWithFormat:@"%ld",strtoul([tempStr UTF8String],0,16)];
            [Bytes addObject:tenStr];
        }
    }else{
        for (int i=0; i<strLength/2; i++){
            NSString *tempStr = [str substringWithRange:NSMakeRange(i*2,2)];
            NSString *tenStr = [NSString stringWithFormat:@"%ld",strtoul([tempStr UTF8String],0,16)];
            [Bytes addObject:tenStr];
        }
        
        NSString *lastStr = [NSString stringWithFormat:@"0%@",[str substringWithRange:NSMakeRange(strLength-1,1)]];
        NSString *endStr = [NSString stringWithFormat:@"%ld",strtoul([lastStr UTF8String],0,16)];
        [Bytes addObject:endStr];
        
    }
    return Bytes;
}

#pragma mark- byte数组元素--->int值
+ (NSUInteger)getIntegerWith:(NSArray*)array{
    NSUInteger returnInt = 0;
    for (int i=0;i<[array count];i++){
        NSUInteger tempInt = [[array objectAtIndex:i] integerValue];
        returnInt = returnInt + (tempInt<<(8*([array count]-1-i)));
    }
    return returnInt;
}

#pragma mark- int--->字节数组(byte[8])
+(NSArray*)getBytesWithInt:(NSInteger)value{
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (int i=0; i<8; i++){
        if ([[NSString stringWithFormat:@"%hhu",((Byte) ((value>>(8*(8-1-i))) & 0xFF))] integerValue] !=0 ){
            [array addObject:[NSString stringWithFormat:@"%hhu",((Byte) ((value>>(8*(8-1-i))) & 0xFF))]];
        }
    }
    return array;
}

#pragma mark- 十进制转换为十六进制
+ (NSString *)getHexByDecimal:(NSUInteger)decimal {
    
    NSString *hex =@"";
    NSString *letter;
    NSInteger number;
    for (int i = 0; i<9; i++) {
        
        number = decimal % 16;
        decimal = decimal / 16;
        switch (number) {
                
            case 10:
                letter =@"a"; break;
            case 11:
                letter =@"b"; break;
            case 12:
                letter =@"c"; break;
            case 13:
                letter =@"d"; break;
            case 14:
                letter =@"e"; break;
            case 15:
                letter =@"f"; break;
            default:
                letter = [NSString stringWithFormat:@"%ld", number];
        }
        hex = [letter stringByAppendingString:hex];
        if (decimal == 0) {
            break;
        }
    }
    
    if (hex.length == 1) {
        return [NSString stringWithFormat:@"0%@",hex];
    }
    else{
        return hex;
    }
}

#pragma mark- int--->byteCount个字节数组->反转->hex
+ (NSString *)getEndHexStringWithValue:(NSUInteger)value byteCount:(NSUInteger)byteCount{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    NSString *returnStr = @"";
    
    for (int i=0; i<byteCount; i++){
        //        byte[i] =  (Byte) ((value>>(8*(byteCount-1-i))) & 0xFF);
        //        Byte byte[4] = {};
        //        byte[0] =  (Byte) ((value>>24) & 0xFF);
        //        byte[1] =  (Byte) ((value>>16) & 0xFF);
        //        byte[2] =  (Byte) ((value>>8) & 0xFF);
        //        byte[3] =  (Byte) (value & 0xFF);
        
        [array addObject:[NSString stringWithFormat:@"%hhu",((Byte) ((value>>(8*(byteCount-1-i))) & 0xFF))]];
    }
    
    NSArray *reversedArray = [[array reverseObjectEnumerator] allObjects];
    
    for (int i=0; i<byteCount; i++){
        NSString *tempStr = [self getHexByDecimal:[[reversedArray objectAtIndex:i] integerValue]];
        returnStr = [returnStr stringByAppendingString:tempStr];
    }
    return returnStr;
}

#pragma mark- int--->byteCount个字节数组
+ (NSArray *)getByteArrayWithValue:(NSUInteger)value byteCount:(NSUInteger)byteCount{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (int i=0; i<byteCount; i++){
        [array addObject:[NSString stringWithFormat:@"%hhu",((Byte) ((value>>(8*(byteCount-1-i))) & 0xFF))]];
    }
    return array;
}

#pragma mark- 数组长度序列化
+ (NSArray *)getArrayLengthSerializationWithValue:(NSUInteger)value{
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    NSInteger arrayCount = 0;
    
    if (value < 253/* 0x00FD */) {
        arrayCount = 1;
        [array addObject:[NSString stringWithFormat:@"%hhu",((Byte) (value & 0xFF))]];
    } else if (value <= 65535/* 0xFFFF */){
        arrayCount = 3;
        [array addObject:@"253"];
    } else if (value <= 4294967295 /* 0xFFFFFFFF */){
        arrayCount = 5;
        [array addObject:@"254"];
    } else {
        arrayCount = 9;
        [array addObject:@"255"];
    }
    
    if (arrayCount>1){
        //int ---> byte[]
        NSArray *tempArray = [self getBytesWithInt:value];
        NSArray *reversedArray = [[tempArray reverseObjectEnumerator] allObjects];
        NSInteger reversedArrayCount = reversedArray.count;
        
        if (arrayCount == 3 && reversedArray.count >1) {
            [array addObject:[reversedArray objectAtIndex:reversedArrayCount-2]];
            [array addObject:[reversedArray objectAtIndex:reversedArrayCount-1]];
        }else if (arrayCount == 5 && reversedArray.count >3){
            [array addObject:[reversedArray objectAtIndex:reversedArrayCount-4]];
            [array addObject:[reversedArray objectAtIndex:reversedArrayCount-3]];
            [array addObject:[reversedArray objectAtIndex:reversedArrayCount-2]];
            [array addObject:[reversedArray objectAtIndex:reversedArrayCount-1]];
        }else if (arrayCount == 9 && reversedArray.count >7){
            [array addObject:[reversedArray objectAtIndex:reversedArrayCount-8]];
            [array addObject:[reversedArray objectAtIndex:reversedArrayCount-7]];
            [array addObject:[reversedArray objectAtIndex:reversedArrayCount-6]];
            [array addObject:[reversedArray objectAtIndex:reversedArrayCount-5]];
            [array addObject:[reversedArray objectAtIndex:reversedArrayCount-4]];
            [array addObject:[reversedArray objectAtIndex:reversedArrayCount-3]];
            [array addObject:[reversedArray objectAtIndex:reversedArrayCount-2]];
            [array addObject:[reversedArray objectAtIndex:reversedArrayCount-1]];
        }
    }
    return array;
}

+ (NSData *)dataFromHexString:(NSString*)hexString
{
    NSString * cleanString = [self cleanNonHexCharsFromHexString:hexString];
    if (cleanString == nil) {
        return nil;
    }
    
    NSMutableData *result = [[NSMutableData alloc] init];
    
    int i = 0;
    for (i = 0; i+2 <= cleanString.length; i+=2) {
        NSRange range = NSMakeRange(i, 2);
        NSString* hexStr = [cleanString substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        unsigned char uc = (unsigned char) intValue;
        [result appendBytes:&uc length:1];
    }
    NSData * data = [NSData dataWithData:result];
    return data;
}

+ (NSString *)cleanNonHexCharsFromHexString:(NSString *)input
{
    if (input == nil) {
        return nil;
    }
    
    NSString * output = [input stringByReplacingOccurrencesOfString:@"0x" withString:@""
                                                            options:NSCaseInsensitiveSearch range:NSMakeRange(0, input.length)];
    NSString * hexChars = @"0123456789abcdefABCDEF";
    NSCharacterSet *hexc = [NSCharacterSet characterSetWithCharactersInString:hexChars];
    NSCharacterSet *invalidHexc = [hexc invertedSet];
    NSString * allHex = [[output componentsSeparatedByCharactersInSet:invalidHexc] componentsJoinedByString:@""];
    return allHex;
}

#pragma mark- 数组长度序列化
+ (NSArray *)writeVariableStackIntWithValue:(NSUInteger)value{
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    NSInteger arrayCount = 0;
    
    if (value < 76/* 0x004C */) {
        arrayCount = 1;
        [array addObject:[NSString stringWithFormat:@"%hhu",((Byte) (value & 0xFF))]];
    } else if (value < 255/* 0x00FF */) {
        arrayCount = 2;
        [array addObject:@"76"];
    } else if (value <= 65535/* 0xFFFF */){
        arrayCount = 3;
        [array addObject:@"77"];
    } else {
        arrayCount = 5;
        [array addObject:@"78"];
    }
    
    if (arrayCount>1){
        //int ---> byte[]
        NSArray *tempArray = [self getBytesWithInt:value];
        NSArray *reversedArray = [[tempArray reverseObjectEnumerator] allObjects];
        NSInteger reversedArrayCount = reversedArray.count;
        
        if (arrayCount == 2 && reversedArray.count >0){
            [array addObject:[reversedArray objectAtIndex:reversedArrayCount-1]];
        }else if (arrayCount == 3 && reversedArray.count >1) {
            [array addObject:[reversedArray objectAtIndex:reversedArrayCount-2]];
            [array addObject:[reversedArray objectAtIndex:reversedArrayCount-1]];
        }else if (arrayCount == 5 && reversedArray.count >3){
            [array addObject:[reversedArray objectAtIndex:reversedArrayCount-4]];
            [array addObject:[reversedArray objectAtIndex:reversedArrayCount-3]];
            [array addObject:[reversedArray objectAtIndex:reversedArrayCount-2]];
            [array addObject:[reversedArray objectAtIndex:reversedArrayCount-1]];
        }
    }
    return array;
}

@end
