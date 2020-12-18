//
//  GJDevice.m
//  CowaRBTest
//
//  Created by gaojun on 2016/11/15.
//  Copyright © 2016年 Fan ren. All rights reserved.
//

#import "GJDevice.h"
#import "FFTool.h"
#import "GetCRC.h"

@implementation GJDevice

+(GJDevice *)sharedInstance
{
    static GJDevice *device = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        device = [[GJDevice alloc]init];
    });
    return device;
}

-(id)init{
    self = [super init];
    if(self)
    {
        
        _lastData = [NSData data];
//        self.index = 0;
//        self.fileIndex = 0;
       

    }
    return self;
}

//传输文件之前首先先发送类型指令
-(NSMutableData *)sendFileDataWithName:(NSString *)name AndSize:(NSUInteger)size Type:(NSString *)type MD5Str:(NSString *)md5
{
    //序号
    NSString *hexStr = [FFTool ToHex:self.index];
    
    self.index++;
    //字符串补0
    NSMutableString *buquanStr = [NSMutableString stringWithFormat:@"00000000%@",hexStr];
    NSMutableString *hexString = [NSMutableString string];
    NSUInteger length = buquanStr.length;
    for (long i=length-8;i<=length-1;i++){
        unichar c = [buquanStr characterAtIndex:i];
        [hexString appendString:[NSString stringWithFormat:@"%c",c]];
    }
    //字符串截取
    NSMutableArray *array = [NSMutableArray array];
    for (int i=0;i<=6;i=i+2){
        NSString *str = [hexString substringWithRange:NSMakeRange(i, 2)];
        [array addObject:str];
    }
    //数组元素翻转
    NSMutableArray *array2 =[NSMutableArray array];
    for(int i=3;i>=0;i--){
        [array2 addObject:array[i]];
    }
    [array2 replaceObjectAtIndex:3 withObject:@"80"];
    //数组转为字符串
    NSString *seqStr =[FFTool arrayChangeToString:array2 withSplit:@","];
    
    NSString *hexStr2 = [FFTool ToHex:size];
    //字符串补0
    NSMutableString *buquanStr2 = [NSMutableString stringWithFormat:@"00000000%@",hexStr2];
    NSMutableString *hexString2 = [NSMutableString string];
    NSUInteger length2 = buquanStr2.length;
    for (long i=length2-8;i<=length2-1;i++){
        unichar c = [buquanStr2 characterAtIndex:i];
        [hexString2 appendString:[NSString stringWithFormat:@"%c",c]];
    }
    //字符串截取
    NSMutableArray *array3 = [NSMutableArray array];
    for (int i=0;i<=6;i=i+2){
        NSString *str = [hexString2 substringWithRange:NSMakeRange(i, 2)];
        [array3 addObject:str];
    }
    //数组元素翻转
    NSMutableArray *array4 =[NSMutableArray array];
    for(int i=3;i>=0;i--){
        [array4 addObject:array3[i]];
    }
    //数组转为字符串
    NSString *sizeStr =[FFTool arrayChangeToString:array4 withSplit:@","];
    
    
   
    //NSString *md5Str = [GJTool hexStringFromString:md5];
    NSMutableArray *md5Array = [NSMutableArray array];
    for (int i=0;i<=md5.length-2;i=i+2){
        NSString *str = [md5 substringWithRange:NSMakeRange(i, 2)];
        [md5Array addObject:str];
    }
    NSString *md5String = [FFTool arrayChangeToString:md5Array withSplit:@","];
    //NSLog(@"%@",md5String);
    
    int buchongLen = 100 - md5Array.count;
    NSMutableString *buchongStr = [NSMutableString string];
    for(int i=1;i<=buchongLen;i++){
        [buchongStr appendString:@"00,"];
    }
    NSString *buchong = [buchongStr substringToIndex:buchongStr.length-1];
    //NSLog(@"%@",buchong);
    
    NSMutableString *cmdStr = [NSMutableString stringWithFormat:@"03,15,%@,23,%@,00,00,10,%@,%@",seqStr,sizeStr,md5String,buchong];
    
    
    NSArray *oxs = [cmdStr componentsSeparatedByString:@","];
    Byte bytes[oxs.count];
    for (int i = 0; i < oxs.count; i++) {
        const char *s = [oxs[i] UTF8String];
        Byte byte = (Byte)strtol(s, NULL, 16);
        bytes[i] = byte;
    }
    uint mybyte2;
    mybyte2=[GetCRC getCRCWith:bytes :oxs.count];
    
    NSString *cmdStr3 = [FFTool arrayChangeToString:oxs withSplit:@""];


    long long int dataLen = 121 ;
    NSString *dataLenHex = [FFTool ToHex:dataLen];
    
    NSString *str = [NSString string];
    str=[NSString stringWithFormat:@"434F%@%@%04x5741",dataLenHex,cmdStr3,mybyte2];
    
    
    NSMutableData *hexData=[FFTool chengeHexToDataWithString:str withType:100];
    
    _lastData = hexData;
  
    return hexData;
}


#pragma mark -- 传输文件
-(NSData *)sendFileData:(NSData *)data Type:(NSString *)type
{
    //序号
    NSString *hexStr = [FFTool ToHex:self.index];
    
    self.index++;
    //字符串补0
    NSMutableString *buquanStr = [NSMutableString stringWithFormat:@"00000000%@",hexStr];
    NSMutableString *hexString = [NSMutableString string];
    NSUInteger length = buquanStr.length;
    for (long i=length-8;i<=length-1;i++){
        unichar c = [buquanStr characterAtIndex:i];
        [hexString appendString:[NSString stringWithFormat:@"%c",c]];
    }
    //字符串截取
    NSMutableArray *array = [NSMutableArray array];
    for (int i=0;i<=6;i=i+2){
        NSString *str = [hexString substringWithRange:NSMakeRange(i, 2)];
        [array addObject:str];
    }
    //数组元素翻转
    NSMutableArray *array2 =[NSMutableArray array];
    for(int i=3;i>=0;i--){
        [array2 addObject:array[i]];
    }
    [array2 replaceObjectAtIndex:3 withObject:@"80"];
    //数组转为字符串
    NSString *seqStr =[FFTool arrayChangeToString:array2 withSplit:@","];
    
    NSString *stateFlag = @"02";
    
    
    if (self.fileIndex > 65535) {
        self.fileIndex = 0;
    }
    NSString *indexStr = [FFTool ToHex:self.fileIndex];
    //字符串补0
    NSMutableString *buquanStrY = [NSMutableString stringWithFormat:@"0000%@",indexStr];
    NSMutableString *hexStringY = [NSMutableString string];
    NSUInteger lengthY = buquanStrY.length;
    for (long i=lengthY-4;i<=lengthY-1;i++){
        unichar c = [buquanStrY characterAtIndex:i];
        [hexStringY appendString:[NSString stringWithFormat:@"%c",c]];
    }
    //字符串截取
    NSMutableArray *arrayY = [NSMutableArray array];
    for (int i=0;i<=2;i=i+2){
        NSString *strY = [hexStringY substringWithRange:NSMakeRange(i, 2)];
        [arrayY addObject:strY];
    }
    //数组元素翻转
    NSMutableArray *array2Y =[NSMutableArray array];
    for(int i=1;i>=0;i--){
        [array2Y addObject:arrayY[i]];
    }
    //数组转为字符串
    NSString *indexStrHex = [FFTool arrayChangeToString:array2Y withSplit:@","];
    self.fileIndex++;
    
    NSLog(@"数据长度:%lu",(unsigned long)data.length);
    
    
    long long int dataLen = data.length;
    NSString *dataLenHex = [FFTool ToHex:dataLen];
    
   
    NSMutableString *cmdStr=[NSMutableString string];
    if (dataLen<100){
        
        NSMutableString *buchongStr = [NSMutableString string];
        for(int i=1;i<=100-dataLen;i++){
            [buchongStr appendString:@"00,"];
        }
        NSString *buchong = [buchongStr substringToIndex:buchongStr.length-1];
        
        NSString *dataStr = [NSString stringWithFormat:@"%@",data];
        dataStr = [dataStr substringWithRange:NSMakeRange(1, dataStr.length-2)];
        NSMutableString *dataStr2 = [NSMutableString stringWithString:dataStr];
        [dataStr2 replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:NSMakeRange(0, dataStr.length)];
        //字符串截取
        NSMutableArray *dataStrArray = [NSMutableArray array];
        for (int i=0;i<=dataStr2.length - 2 ;i=i+2){
            NSString *strY = [dataStr2 substringWithRange:NSMakeRange(i, 2)];
            [dataStrArray addObject:strY];
        }
        //数组转为字符串
        NSString *dataString = [FFTool arrayChangeToString:dataStrArray withSplit:@","];

        
        cmdStr = [NSMutableString stringWithFormat:@"03,15,%@,%@,00,00,00,00,%@,%@,%@,%@",seqStr,stateFlag,indexStrHex,dataLenHex,dataString,buchong];
    }else{
        
        NSString *dataStr = [NSString stringWithFormat:@"%@",data];
        dataStr = [dataStr substringWithRange:NSMakeRange(1, dataStr.length-2)];
        NSMutableString *dataStr2 = [NSMutableString stringWithString:dataStr];
        [dataStr2 replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:NSMakeRange(0, dataStr.length)];
        //字符串截取
        NSMutableArray *dataStrArray = [NSMutableArray array];
        for (int i=0;i<=dataStr2.length - 2 ;i=i+2){
            NSString *strY = [dataStr2 substringWithRange:NSMakeRange(i, 2)];
            [dataStrArray addObject:strY];
        }
        //数组转为字符串
        NSString *dataString = [FFTool arrayChangeToString:dataStrArray withSplit:@","];

        cmdStr = [NSMutableString stringWithFormat:@"03,15,%@,%@,00,00,00,00,%@,%@,%@",seqStr,stateFlag,indexStrHex,dataLenHex,dataString];
    }
    
    
    NSArray *oxs = [cmdStr componentsSeparatedByString:@","];
    Byte bytes[oxs.count];
    for (int i = 0; i < oxs.count; i++) {
        const char *s = [oxs[i] UTF8String];
        Byte byte = (Byte)strtol(s, NULL, 16);
        bytes[i] = byte;
    }
    uint mybyte2;
    mybyte2=[GetCRC getCRCWith:bytes :oxs.count];
    
    NSString *cmdStr3 = [FFTool arrayChangeToString:oxs withSplit:@""];
    
    long long int wholeDataLen = 121 ;
    NSString *wholeDataLenHex = [FFTool ToHex:wholeDataLen];
    
    NSMutableString *sendDataStr = [NSMutableString stringWithFormat:@"434F%@%@%04x5741",wholeDataLenHex,cmdStr3,mybyte2];
    

    NSData *hexData=[FFTool convertHexStrToData:sendDataStr];
    
    
    _lastData = hexData;
    
    return hexData;
    
}

//上传上一次数据
-(NSData *)sendLastData
{
    return _lastData;
}

//发送结束EOT
-(NSData *)sendEOTWithData
{
    //序号
    NSString *hexStr = [FFTool ToHex:self.index];
  
    self.index++;
    //字符串补0
    NSMutableString *buquanStr = [NSMutableString stringWithFormat:@"00000000%@",hexStr];
    NSMutableString *hexString = [NSMutableString string];
    NSUInteger length = buquanStr.length;
    for (long i=length-8;i<=length-1;i++){
        unichar c = [buquanStr characterAtIndex:i];
        [hexString appendString:[NSString stringWithFormat:@"%c",c]];
    }
    //字符串截取
    NSMutableArray *array = [NSMutableArray array];
    for (int i=0;i<=6;i=i+2){
        NSString *str = [hexString substringWithRange:NSMakeRange(i, 2)];
        [array addObject:str];
    }
    //数组元素翻转
    NSMutableArray *array2 =[NSMutableArray array];
    for(int i=3;i>=0;i--){
        [array2 addObject:array[i]];
    }
    [array2 replaceObjectAtIndex:3 withObject:@"80"];
    //数组转为字符串
    NSString *seqStr =[FFTool arrayChangeToString:array2 withSplit:@","];
    
    
    NSString *stateFlag = @"04";
    
    
    if (self.fileIndex > 65535) {
        self.fileIndex = 0;
    }
    NSString *indexStr = [FFTool ToHex:self.fileIndex];
    //字符串补0
    NSMutableString *buquanStrY = [NSMutableString stringWithFormat:@"0000%@",indexStr];
    NSMutableString *hexStringY = [NSMutableString string];
    NSUInteger lengthY = buquanStrY.length;
    for (long i=lengthY-4;i<=lengthY-1;i++){
        unichar c = [buquanStrY characterAtIndex:i];
        [hexStringY appendString:[NSString stringWithFormat:@"%c",c]];
    }
    //字符串截取
    NSMutableArray *arrayY = [NSMutableArray array];
    for (int i=0;i<=2;i=i+2){
        NSString *strY = [hexStringY substringWithRange:NSMakeRange(i, 2)];
        [arrayY addObject:strY];
    }
    //数组元素翻转
    NSMutableArray *array2Y =[NSMutableArray array];
    for(int i=1;i>=0;i--){
        [array2Y addObject:arrayY[i]];
    }
    //数组转为字符串
    NSString *indexStrHex = [FFTool arrayChangeToString:array2Y withSplit:@","];
    self.fileIndex++;
    
    NSMutableString *buchongStr = [NSMutableString string];
    for(int i=1;i<=99;i++){
        [buchongStr appendString:@"00,"];
    }
    NSString *buchong = [buchongStr substringToIndex:buchongStr.length-1];
    
    NSMutableString *cmdStr = [NSMutableString stringWithFormat:@"03,15,%@,%@,00,00,00,00,%@,01,04,%@",seqStr,stateFlag,indexStrHex,buchong];
    NSArray *oxs = [cmdStr componentsSeparatedByString:@","];
    Byte bytes[oxs.count];
    for (int i = 0; i < oxs.count; i++) {
        const char *s = [oxs[i] UTF8String];
        Byte byte = (Byte)strtol(s, NULL, 16);
        bytes[i] = byte;
    }
    uint mybyte2;
    mybyte2=[GetCRC getCRCWith:bytes :oxs.count];
    
    NSString *cmdStr3 = [FFTool arrayChangeToString:oxs withSplit:@""];
    
    long long int wholeDataLen = 121 ;
    NSString *wholeDataLenHex = [FFTool ToHex:wholeDataLen];
    
    NSMutableString *sendDataStr = [NSMutableString stringWithFormat:@"434F%@%@%04x5741",wholeDataLenHex,cmdStr3,mybyte2];
    
    NSData *hexData=[FFTool convertHexStrToData:sendDataStr];
    
    _lastData = hexData;
    
    return hexData;
    
}


@end
