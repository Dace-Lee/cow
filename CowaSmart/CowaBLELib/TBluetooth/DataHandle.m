//
//  DataHandle.m
//  CowaBLE
//
//  Created by gaojun on 2017/9/13.
//  Copyright © 2017年 mx. All rights reserved.
//

#import "DataHandle.h"
#import "FFTool.h"
#import "HexTool.h"
#import "GetCRC.h"
#import "TBLEDefines.h"

/**
     You can make this .m simpler , But I really don't want to do this .
 */

@implementation DataHandle
+(DataHandle *)sharedInstance
{
    static DataHandle *dataPrepare = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataPrepare = [[DataHandle alloc]init];
    });
    return dataPrepare;
}

-(id)init{
    self = [super init];
    if(self)
    {
        self.index = 0;
        _lastData = [NSData data];
        
    }
    return self;
}

//心跳包
-(NSMutableData *)sendHeartBeat
{
    NSString *hexStr = [FFTool ToHex:self.index];
    self.index++;
    NSString *seqStr =[HexTool create32HexStartWith80:hexStr];
    
    NSTimeInterval interVal = [[NSDate date] timeIntervalSince1970];
    NSString *timeString = [FFTool ToHex:(int)interVal];
    NSString *timeStr = [FFTool To32:timeString];
    
    NSString *cmdStr =[[NSString alloc]initWithFormat:@"03,1A,%@,%@",seqStr,timeStr];
    
    NSArray *oxs = [cmdStr componentsSeparatedByString:@","];
    Byte bytes[oxs.count];
    for (int i = 0; i < oxs.count; i++) {
        const char *s = [oxs[i] UTF8String];
        Byte byte = (Byte)strtol(s, NULL, 16);
        bytes[i] = byte;
    }
    uint mybyte2=[GetCRC getCRCWith:bytes :10];
    
    NSString *cmdStr3 = [FFTool arrayChangeToString:oxs withSplit:@""];
    
    NSString *str = [NSString stringWithFormat:@"434F11%@%04x5741",cmdStr3,mybyte2];
    
    NSMutableData *hexData=[FFTool chengeHexToDataWithString:str withType:300];
    return hexData;
}

-(NSMutableData *)writeWithType:(int)type withFloatX:(float)x FloatY:(float)y ssid:(NSString *)ssid pwd:(NSString *)pwd
{
    NSString *hexStr = [FFTool ToHex:self.index];
    self.index++;
    NSString *seqStr =[HexTool create32HexStartWith80:hexStr];
    
    NSMutableString *cmdStr = [NSMutableString string];
    
    NSString *seqStrX=[NSString string];
    NSString *seqStrY=[NSString string];
    if (type == MOVE_CMD){
        //NSString *hexX= [FFTool ToHex:(int)x];
        NSString *hexX=[NSString stringWithFormat:@"%1x",(int)x];
        seqStrX =[HexTool create16Hex:hexX];
        
        //NSString *hexY= [FFTool ToHex:(int)y];
        NSString *hexY=[NSString stringWithFormat:@"%1x",(int)y];
        seqStrY =[HexTool create16Hex:hexY];
    }
    
    NSMutableString *maxSpeedStr=[NSMutableString string];
    int maxS;
    NSString *seqStrZ=[NSString string];
    if(type==SPEED_SET){
        maxSpeedStr=[NSMutableString stringWithFormat:@"%2.1f",x];
        //NSLog(@"-------------%@",maxSpeedStr);
        maxS=[maxSpeedStr floatValue]*1000;
        
        NSString *hexZ=[NSString stringWithFormat:@"%1x",maxS];
        seqStrZ =[HexTool create16Hex:hexZ];
    }
    
    NSString *ssidStr = [NSString string];
    NSMutableArray *ssidArray=[NSMutableArray array];
    if (type == WIFI_CONNECT_SSID){
        
        for(int i=0;i<ssid.length;i=i+2){
            NSString *str = [ssid substringWithRange:NSMakeRange(i, 2)];
            [ssidArray addObject:str];
        }
        ssidStr=[FFTool arrayChangeToString:ssidArray withSplit:@","];
    }
    
    NSString *pwdStr = [NSString string];
    NSMutableArray *pwdArray=[NSMutableArray array];
    if (type == WIFI_CONNECT_PWD){
        
        for(int i=0;i<pwd.length;i=i+2){
            NSString *str = [pwd substringWithRange:NSMakeRange(i, 2)];
            [pwdArray addObject:str];
        }
        pwdStr=[FFTool arrayChangeToString:pwdArray withSplit:@","];
    }
    switch (type) {
        case MAIN_LOCK_OPEN:
            cmdStr = [NSMutableString stringWithFormat:@"01,14,%@,02",seqStr];
            break;
        case MAIN_LOCK_CLOSE:
            cmdStr = [NSMutableString stringWithFormat:@"01,14,%@,03",seqStr];
            break;
        case BEHIND_LOCK_OPEN:
            cmdStr = [NSMutableString stringWithFormat:@"01,16,%@,02",seqStr];
            break;
        case BEHIND_LOCK_CLOSE:
            cmdStr = [NSMutableString stringWithFormat:@"01,16,%@,03",seqStr];
            break;
        case ANTICLOCK_WISE_OPEN:
            cmdStr = [NSMutableString stringWithFormat:@"04,07,%@,00,00,32,00",seqStr];
            break;
        case ANTICLOCK_WISE_CLOSE:
            cmdStr = [NSMutableString stringWithFormat:@"04,07,%@,00,00,00,00",seqStr];
            break;
        case CLOCK_WISE_OPEN:
            cmdStr = [NSMutableString stringWithFormat:@"04,07,%@,00,00,CE,FF",seqStr];
            break;
        case CLOCK_WISE_CLOSE:
            cmdStr = [NSMutableString stringWithFormat:@"04,07,%@,00,00,00,00",seqStr];
            break;
        case AVOID_HAZARD_OPEN:
            cmdStr = [NSMutableString stringWithFormat:@"01,0E,%@,02,02",seqStr];
            break;
        case AVOID_HAZARD_CLOSE:
            cmdStr = [NSMutableString stringWithFormat:@"01,0E,%@,02,00",seqStr];
            break;
        case FIND_ME_OPEN:
            cmdStr = [NSMutableString stringWithFormat:@"01,0E,%@,10,10",seqStr];
            break;
        case FIND_ME_CLOSE:
            cmdStr = [NSMutableString stringWithFormat:@"01,0E,%@,10,00",seqStr];
            break;
            
        case MANNAL_OPEN:
            cmdStr = [NSMutableString stringWithFormat:@"01,0E,%@,08,08",seqStr];
            break;
        case MANNAL_CLOSE:
            cmdStr = [NSMutableString stringWithFormat:@"01,0E,%@,08,00",seqStr];
            break;
        case ENABLE_OPEN:
            cmdStr = [NSMutableString stringWithFormat:@"01,09,%@,02,02",seqStr];
            break;
        case ENABLE_CLOSE:
            cmdStr = [NSMutableString stringWithFormat:@"01,09,%@,02,00",seqStr];
            break;
        case WIFI_OPEN:
            cmdStr = [NSMutableString stringWithFormat:@"01,0E,%@,04,04",seqStr];
            break;
        case WIFI_CLOSE:
            cmdStr = [NSMutableString stringWithFormat:@"01,0E,%@,04,00",seqStr];
            break;
        case ABRUP_STOP_OPEN:
            cmdStr = [NSMutableString stringWithFormat:@"01,0E,%@,01,01",seqStr];
            break;
        case ABRUP_STOP_CLOSE:
            cmdStr = [NSMutableString stringWithFormat:@"01,0E,%@,01,00",seqStr];
            break;
        case WHEEL_UP:
            cmdStr = [NSMutableString stringWithFormat:@"01,09,%@,04,04",seqStr];
            break;
        case WHEEL_DOWN:
            cmdStr = [NSMutableString stringWithFormat:@"01,09,%@,04,00",seqStr];
            break;
        case MOVE_CMD:
            cmdStr = [NSMutableString stringWithFormat:@"04,07,%@,%@,%@",seqStr,seqStrY,seqStrX];
            // NSLog(@"%@",cmdStr);
            break;
        case SPEED_SET:
            cmdStr = [NSMutableString stringWithFormat:@"04,10,%@,%@",seqStr,seqStrZ];
            break;
        case LAMP_SET_CLOSE:
            cmdStr = [NSMutableString stringWithFormat:@"01,14,%@,0A",seqStr];
            break;
        case LAMP_SET_RED:
            cmdStr = [NSMutableString stringWithFormat:@"01,14,%@,0B",seqStr];
            break;
        case LAMP_SET_GREEN:
            cmdStr = [NSMutableString stringWithFormat:@"01,14,%@,0C",seqStr];
            break;
        case LAMP_SET_BLUE:
            cmdStr = [NSMutableString stringWithFormat:@"01,14,%@,0D",seqStr];
            break;
        case WIFI_CONNECT_SSID:
            cmdStr = [NSMutableString stringWithFormat:@"01,0F,%@,01,%@",seqStr,ssidStr];
            break;
        case WIFI_CONNECT_PWD:
            cmdStr = [NSMutableString stringWithFormat:@"01,0F,%@,00,%@",seqStr,pwdStr];
            break;
        default:
            break;
    }
    
    NSArray *oxs = [cmdStr componentsSeparatedByString:@","];
    Byte bytes[oxs.count];
    for (int i = 0; i < oxs.count; i++) {
        const char *s = [oxs[i] UTF8String];
        Byte byte = (Byte)strtol(s, NULL, 16);
        bytes[i] = byte;
    }
    
    NSString *cmdStr3 = [FFTool arrayChangeToString:oxs withSplit:@""];
    
    uint mybyte2;
    if(type == MOVE_CMD || type == ANTICLOCK_WISE_OPEN || type == ANTICLOCK_WISE_CLOSE || type == CLOCK_WISE_OPEN || type == CLOCK_WISE_CLOSE){
        mybyte2=[GetCRC getCRCWith:bytes :10];
    }else if (type == LAMP_SET_CLOSE || type == LAMP_SET_RED || type == LAMP_SET_GREEN || type == LAMP_SET_BLUE || type == MAIN_LOCK_OPEN || type == MAIN_LOCK_CLOSE || type == BEHIND_LOCK_OPEN || type == BEHIND_LOCK_CLOSE){
        mybyte2=[GetCRC getCRCWith:bytes :7];
    }else if (type == WIFI_CONNECT_SSID){
        int length =  ssidArray.count;
        mybyte2=[GetCRC getCRCWith:bytes :length+7];
    }else if (type == WIFI_CONNECT_PWD){
        int length =  pwdArray.count;
        mybyte2=[GetCRC getCRCWith:bytes :length+7];
    }else{
        mybyte2=[GetCRC getCRCWith:bytes :8];
    }
    
    
    NSString *str = [NSString string];
    if(type == MOVE_CMD || type == ANTICLOCK_WISE_OPEN || type == ANTICLOCK_WISE_CLOSE || type == CLOCK_WISE_OPEN || type == CLOCK_WISE_CLOSE){
        str=[NSString stringWithFormat:@"434F11%@%04x5741",cmdStr3,mybyte2];
        
        if (str.length == 34){
            NSMutableData *hexData=[FFTool chengeHexToDataWithString:str withType:type];
             //NSLog(@"********%@",str);
            return hexData;
        }else{return nil;}
    }else if (type == LAMP_SET_CLOSE || type == LAMP_SET_RED || type == LAMP_SET_GREEN || type == LAMP_SET_BLUE || type == MAIN_LOCK_OPEN || type == MAIN_LOCK_CLOSE || type == BEHIND_LOCK_OPEN || type == BEHIND_LOCK_CLOSE){
        str=[NSString stringWithFormat:@"434F0E%@%04x5741",cmdStr3,mybyte2];
        
        if (str.length == 28){
            NSMutableData *hexData=[FFTool chengeHexToDataWithString:str withType:type];
             //NSLog(@"********%@",str);
            return hexData;
        }else{return nil;}
    }else if (type == WIFI_CONNECT_SSID){
        int lenth = ssidArray.count + 7 + 2 + 5;
        NSString *ssidhex = [FFTool ToHex:lenth];
        str=[NSString stringWithFormat:@"434F%@%@%04x5741",ssidhex,cmdStr3,mybyte2];
        
        if (str.length == lenth*2){
            NSMutableData *hexData=[FFTool chengeHexToDataWithString:str withType:type];
             //NSLog(@"********%@",str);
            return hexData;
        }else{return nil;}
    }else if (type == WIFI_CONNECT_PWD){
        int lenth = pwdArray.count + 7 + 2 + 5;
        NSString *pwdhex = [FFTool ToHex:lenth];
        str=[NSString stringWithFormat:@"434F%@%@%04x5741",pwdhex,cmdStr3,mybyte2];
        
        if (str.length == lenth*2){
            NSMutableData *hexData=[FFTool chengeHexToDataWithString:str withType:type];
            //NSLog(@"********%@",str);
            return hexData;
        }else{return nil;}
    }else{
        str=[NSString stringWithFormat:@"434F0F%@%04x5741",cmdStr3,mybyte2];
        
        if (str.length == 30){
            NSMutableData *hexData=[FFTool chengeHexToDataWithString:str withType:type];
            //NSLog(@"********%@",str);
            return hexData;
        }else{return nil;}
    }
    
}

//传输文件之前首先先发送类型指令
-(NSData *)sendFileDataWithName:(NSString *)name AndSize:(NSUInteger)size Type:(NSString *)type MD5Str:(NSString *)md5
{
    //序号
    NSString *hexStr = [FFTool ToHex:self.index];
    self.index++;
    NSString *seqStr =[HexTool create32HexStartWith80:hexStr];
    
    
    
    NSString *stateFlag = [NSString string];
    if ([type isEqualToString:@"bldc"]){
        stateFlag = @"20";
    }else if ([type isEqualToString:@"uwb"]){
        stateFlag = @"22";
    }else if ([type isEqualToString:@"mb"]){
        stateFlag = @"21";
    }else if ([type isEqualToString:@"r1"]){
        stateFlag = @"23";
    }
    
    
    NSString *hexStr2 = [FFTool ToHex:size];
    NSString *sizeStr =[HexTool create32Hex:hexStr2];
    
    
    NSString *md5Str = [FFTool hexStringFromString:md5];
    NSMutableArray *md5Array = [NSMutableArray array];
    for (int i=0;i<=md5Str.length-2;i=i+2){
        NSString *str = [md5Str substringWithRange:NSMakeRange(i, 2)];
        [md5Array addObject:str];
    }
    NSString *md5String = [FFTool arrayChangeToString:md5Array withSplit:@","];
    
    
    int buchongLen = 200 - md5Array.count;
    NSMutableString *buchongStr = [NSMutableString string];
    for(int i=1;i<=buchongLen;i++){
        [buchongStr appendString:@"00,"];
    }
    NSString *buchong = [buchongStr substringToIndex:buchongStr.length-1];
    //NSLog(@"%@",buchong);
    
    NSMutableString *cmdStr = [NSMutableString stringWithFormat:@"03,15,%@,%@,%@,00,00,10,%@,%@",seqStr,stateFlag,sizeStr,md5String,buchong];
    
    
    NSArray *oxs = [cmdStr componentsSeparatedByString:@","];
    Byte bytes[oxs.count];
    for (int i = 0; i < oxs.count; i++) {
        const char *s = [oxs[i] UTF8String];
        Byte byte = (Byte)strtol(s, NULL, 16);
        bytes[i] = byte;
    }
    uint mybyte2;
    mybyte2=[GetCRC getCRCWith:bytes :oxs.count];
    NSLog(@"%04x",mybyte2);
    
    NSString *cmdStr3 = [FFTool arrayChangeToString:oxs withSplit:@""];
    
    
    long long int dataLen = 221 ;
    NSString *dataLenHex = [FFTool ToHex:dataLen];
    
    NSString *str = [NSString string];
    str=[NSString stringWithFormat:@"434F%@%@%04x5741",dataLenHex,cmdStr3,mybyte2];
    
    
    NSMutableData *hexData=[FFTool chengeHexToDataWithString:str withType:100];
    NSLog(@"%@",str);
    return hexData;
    
}


#pragma mark -- 传输文件
-(NSData *)sendFileData:(NSData *)data Type:(NSString *)type
{
    //序号
    NSString *hexStr = [FFTool ToHex:self.index];
    self.index++;
    NSString *seqStr =[HexTool create32HexStartWith80:hexStr];
    
    
    NSString *stateFlag = @"02";
    
    
    if (self.fileIndex > 255) {
        self.fileIndex = 0;
    }
    NSString *indexStr = [FFTool ToHex:self.fileIndex];
    NSString *indexStrHex = [HexTool create16Hex:indexStr];
    self.fileIndex++;
    
    NSLog(@"数据长度:%lu",(unsigned long)data.length);
    
    
    long long int dataLen = data.length;
    NSString *dataLenHex = [FFTool ToHex:dataLen];
    
    
    
    NSString *dataStr = [FFTool dataToHexString:data];
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
    
    
    
    NSMutableString *cmdStr = [NSMutableString stringWithFormat:@"03,15,%@,%@,00,00,00,00,%@,%@,%@",seqStr,stateFlag,indexStrHex,dataLenHex,dataString];
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
    
    long long int wholeDataLen = 221 ;
    NSString *wholeDataLenHex = [FFTool ToHex:wholeDataLen];
    
    NSMutableString *sendDataStr = [NSMutableString stringWithFormat:@"434F%@%@%04x5741",wholeDataLenHex,cmdStr3,mybyte2];
    
    NSLog(@"%@",sendDataStr);
    
    NSData *hexData=[FFTool convertHexStrToData:sendDataStr];
    
    return hexData;
    
}

-(void)sendDataTimesWithData:(NSData *)data
{
    int dataLen = data.length;
    int idx = 0;
    int count = 0;
    
    while (1) {
        
        if((dataLen-idx)>100){
            count = 100;
            
        }else if (0<(dataLen-idx)&&(dataLen-idx)<100){
            count = dataLen-idx;
            
        }else if ((dataLen-idx)<=0){
            
            break;
        }
        
        NSData *oneData=[NSData dataWithBytes:data.bytes+idx length:count];
        
        idx += count;
        
        //        AppDelegate *appDelegate = GJAPPDALEGATE;
        //        [appDelegate.peripheral writeValue:oneData forCharacteristic:appDelegate.clockCha type:CBCharacteristicWriteWithoutResponse];
        
        usleep(500*1000);
        
    }
    
    _lastData = data;
    
    
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
    NSString *seqStr =[HexTool create32HexStartWith80:hexStr];
    
    
    NSString *stateFlag = @"04";
    
    
    if (self.fileIndex > 255) {
        self.fileIndex = 0;
    }
    NSString *indexStr = [FFTool ToHex:self.fileIndex];
    NSString *indexStrHex = [HexTool create16Hex:indexStr];
    self.fileIndex++;
    
    
    NSMutableString *buchongStr = [NSMutableString string];
    for(int i=1;i<=199;i++){
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
    
    long long int wholeDataLen = 221 ;
    NSString *wholeDataLenHex = [FFTool ToHex:wholeDataLen];
    
    NSMutableString *sendDataStr = [NSMutableString stringWithFormat:@"434F%@%@%04x5741",wholeDataLenHex,cmdStr3,mybyte2];
    
    NSLog(@"%@",sendDataStr);
    
    NSData *hexData=[FFTool convertHexStrToData:sendDataStr];
    
    return hexData;
}

//获取imei
-(NSMutableData *)getImei
{
    NSString *hexStr = [FFTool ToHex:self.index];
    self.index++;
    NSString *seqStr =[HexTool create32HexStartWith80:hexStr];
    
    //20个0转ascii
    NSMutableData *cmdData = [@"00000000000000000000" dataUsingEncoding:NSASCIIStringEncoding];
    NSString *dataStr = [FFTool dataToHexString:cmdData];
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
    
    NSString *imeiDataStr = [NSString stringWithFormat:@"%@,00,%@",USER_MANAGERID_IMEI,dataString];
    
    NSString *cmdStr =[[NSString alloc]initWithFormat:@"%@,%@,%@,%@",USER_GROUPID,USER_COMMANDID,seqStr,imeiDataStr];
    
    NSArray *oxs = [cmdStr componentsSeparatedByString:@","];
    Byte bytes[oxs.count];
    for (int i = 0; i < oxs.count; i++) {
        const char *s = [oxs[i] UTF8String];
        Byte byte = (Byte)strtol(s, NULL, 16);
        bytes[i] = byte;
    }
    uint mybyte2=[GetCRC getCRCWith:bytes :28];
    
    NSString *cmdStr3 = [FFTool arrayChangeToString:oxs withSplit:@""];
    
    NSString *str = [NSString stringWithFormat:@"434F23%@%04x5741",cmdStr3,mybyte2];
    
    NSMutableData *hexData=[FFTool chengeHexToDataWithString:str withType:300];
    return hexData;

}

//获取version
-(NSMutableData *)getVersion
{
    NSString *hexStr = [FFTool ToHex:self.index];
    self.index++;
    NSString *seqStr =[HexTool create32HexStartWith80:hexStr];
    
    NSString *cmdStr =[[NSString alloc]initWithFormat:@"03,24,%@",seqStr];
    
    NSArray *oxs = [cmdStr componentsSeparatedByString:@","];
    Byte bytes[oxs.count];
    for (int i = 0; i < oxs.count; i++) {
        const char *s = [oxs[i] UTF8String];
        Byte byte = (Byte)strtol(s, NULL, 16);
        bytes[i] = byte;
    }
    uint mybyte2=[GetCRC getCRCWith:bytes :6];
    
    NSString *cmdStr3 = [FFTool arrayChangeToString:oxs withSplit:@""];
    
    NSString *str = [NSString stringWithFormat:@"434F0D%@%04x5741",cmdStr3,mybyte2];
    
    NSMutableData *hexData=[FFTool chengeHexToDataWithString:str withType:300];
    return hexData;
}

//获取host
-(NSMutableData *)getHost
{
    NSString *hexStr = [FFTool ToHex:self.index];
    self.index++;
    NSString *seqStr =[HexTool create32HexStartWith80:hexStr];
    
    //20个0转ascii
    NSMutableData *cmdData = [@"00000000000000000000" dataUsingEncoding:NSASCIIStringEncoding];
    NSString *dataStr = [FFTool dataToHexString:cmdData];
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
    
    NSString *imeiDataStr = [NSString stringWithFormat:@"%@,00,%@",USER_MANAGERID_HOST,dataString];

    
    NSString *cmdStr =[[NSString alloc]initWithFormat:@"%@,%@,%@,%@",USER_GROUPID,USER_COMMANDID,seqStr,imeiDataStr];
    
    NSArray *oxs = [cmdStr componentsSeparatedByString:@","];
    Byte bytes[oxs.count];
    for (int i = 0; i < oxs.count; i++) {
        const char *s = [oxs[i] UTF8String];
        Byte byte = (Byte)strtol(s, NULL, 16);
        bytes[i] = byte;
    }
    uint mybyte2=[GetCRC getCRCWith:bytes :28];
    
    NSString *cmdStr3 = [FFTool arrayChangeToString:oxs withSplit:@""];
    
    NSString *str = [NSString stringWithFormat:@"434F23%@%04x5741",cmdStr3,mybyte2];
    
    NSMutableData *hexData=[FFTool chengeHexToDataWithString:str withType:300];
    return hexData;
}

//申请授权
-(NSMutableData *)authWithNum:(NSString *)num
{
    NSString *hexStr = [FFTool ToHex:self.index];
    self.index++;
    NSString *seqStr =[HexTool create32HexStartWith80:hexStr];
    
    NSInteger zeroNum = 20 - num.length;
    NSMutableString *zeroStr = [NSMutableString string];
    for (int i=0;i<zeroNum;i++){
        [zeroStr appendString:@"0"];
    }
    
    NSString *numLengthHex = [FFTool ToHex:num.length];
    
    NSMutableData *cmdData = [[NSString stringWithFormat:@"%@%@",num,zeroStr] dataUsingEncoding:NSASCIIStringEncoding];
    NSString *dataStr = [FFTool dataToHexString:cmdData];
    NSMutableString *dataStr2 = [NSMutableString stringWithString:dataStr];
    [dataStr2 replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:NSMakeRange(0, dataStr.length)];
    //字符串截取
    NSMutableArray *dataStrArray = [NSMutableArray array];
    for (int i=0;i<=dataStr2.length - 2;i=i+2){
        NSString *strY = [dataStr2 substringWithRange:NSMakeRange(i, 2)];
        [dataStrArray addObject:strY];
    }
    //数组转为字符串
    NSString *dataString = [FFTool arrayChangeToString:dataStrArray withSplit:@","];
    
    NSString *imeiDataStr = [NSString stringWithFormat:@"%@,%@,%@",USER_MANAGERID_AUTH,numLengthHex,dataString];
    
    
    NSString *cmdStr =[[NSString alloc]initWithFormat:@"%@,%@,%@,%@",USER_GROUPID,USER_COMMANDID,seqStr,imeiDataStr];
    
    NSArray *oxs = [cmdStr componentsSeparatedByString:@","];
    Byte bytes[oxs.count];
    for (int i = 0; i < oxs.count; i++) {
        const char *s = [oxs[i] UTF8String];
        Byte byte = (Byte)strtol(s, NULL, 16);
        bytes[i] = byte;
    }
    uint mybyte2=[GetCRC getCRCWith:bytes :28];
    
    NSString *cmdStr3 = [FFTool arrayChangeToString:oxs withSplit:@""];
    
    NSString *str = [NSString stringWithFormat:@"434F23%@%04x5741",cmdStr3,mybyte2];

    NSMutableData *hexData=[FFTool chengeHexToDataWithString:str withType:300];
    return hexData;

}

//reset
-(NSMutableData *)reset
{
    NSString *hexStr = [FFTool ToHex:self.index];
    self.index++;
    NSString *seqStr =[HexTool create32HexStartWith80:hexStr];
    
    //20个0转ascii
    NSMutableData *cmdData = [@"00000000000000000000" dataUsingEncoding:NSASCIIStringEncoding];
    NSString *dataStr = [FFTool dataToHexString:cmdData];
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
    
    NSString *imeiDataStr = [NSString stringWithFormat:@"%@,00,%@",USER_MANAGERID_RESET,dataString];
    
    
    NSString *cmdStr =[[NSString alloc]initWithFormat:@"%@,%@,%@,%@",USER_GROUPID,USER_COMMANDID,seqStr,imeiDataStr];
    
    NSArray *oxs = [cmdStr componentsSeparatedByString:@","];
    Byte bytes[oxs.count];
    for (int i = 0; i < oxs.count; i++) {
        const char *s = [oxs[i] UTF8String];
        Byte byte = (Byte)strtol(s, NULL, 16);
        bytes[i] = byte;
    }
    uint mybyte2=[GetCRC getCRCWith:bytes :28];
    
    NSString *cmdStr3 = [FFTool arrayChangeToString:oxs withSplit:@""];
    
    NSString *str = [NSString stringWithFormat:@"434F23%@%04x5741",cmdStr3,mybyte2];
    
    NSMutableData *hexData=[FFTool chengeHexToDataWithString:str withType:300];
    return hexData;

}

//add user
-(NSMutableData *)addUserWithNum:(NSString *)num
{
    NSString *hexStr = [FFTool ToHex:self.index];
    self.index++;
    NSString *seqStr =[HexTool create32HexStartWith80:hexStr];
    
    NSInteger zeroNum = 20 - num.length;
    NSMutableString *zeroStr = [NSMutableString string];
    for (int i=0;i<zeroNum;i++){
        [zeroStr appendString:@"0"];
    }
    
    NSString *numLengthHex = [FFTool ToHex:num.length];
    
    NSMutableData *cmdData = [[NSString stringWithFormat:@"%@%@",num,zeroStr] dataUsingEncoding:NSASCIIStringEncoding];
    NSString *dataStr = [FFTool dataToHexString:cmdData];
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
    
    NSString *imeiDataStr = [NSString stringWithFormat:@"%@,%@,%@",USER_MANAGERID_ADDUSER,numLengthHex,dataString];
    
    
    NSString *cmdStr =[[NSString alloc]initWithFormat:@"%@,%@,%@,%@",USER_GROUPID,USER_COMMANDID,seqStr,imeiDataStr];
    
    NSArray *oxs = [cmdStr componentsSeparatedByString:@","];
    Byte bytes[oxs.count];
    for (int i = 0; i < oxs.count; i++) {
        const char *s = [oxs[i] UTF8String];
        Byte byte = (Byte)strtol(s, NULL, 16);
        bytes[i] = byte;
    }
    uint mybyte2=[GetCRC getCRCWith:bytes :28];
    
    NSString *cmdStr3 = [FFTool arrayChangeToString:oxs withSplit:@""];
    
    NSString *str = [NSString stringWithFormat:@"434F23%@%04x5741",cmdStr3,mybyte2];
    
    NSMutableData *hexData=[FFTool chengeHexToDataWithString:str withType:300];
    return hexData;

}

//绑定手环
-(NSMutableData *)bindHandleWith:(NSString *)num{
    NSString *hexStr = [FFTool ToHex:self.index];
    self.index++;
    NSString *seqStr =[HexTool create32HexStartWith80:hexStr];
    
    NSString *dataStr = [FFTool hexStringFromString:num];
    //字符串截取
    NSMutableArray *dataStrArray = [NSMutableArray array];
    for (int i=0;i<=dataStr.length - 2 ;i=i+2){
        NSString *strY = [dataStr substringWithRange:NSMakeRange(i, 2)];
        [dataStrArray addObject:strY];
    }
    //数组转为字符串
    NSString *dataString = [FFTool arrayChangeToString:dataStrArray withSplit:@","];
    
    NSString *cmdStr =[[NSString alloc]initWithFormat:@"03,2C,%@,%@",seqStr,dataString];
    
    NSArray *oxs = [cmdStr componentsSeparatedByString:@","];
    Byte bytes[oxs.count];
    for (int i = 0; i < oxs.count; i++) {
        const char *s = [oxs[i] UTF8String];
        Byte byte = (Byte)strtol(s, NULL, 16);
        bytes[i] = byte;
    }
    int length = 6 + dataStrArray.count;
    uint mybyte2=[GetCRC getCRCWith:bytes :length];
    
    NSString *cmdStr3 = [FFTool arrayChangeToString:oxs withSplit:@""];
    
    NSString *str = [NSString stringWithFormat:@"434F%02x%@%04x5741",7+length,cmdStr3,mybyte2];
    
    NSMutableData *hexData=[FFTool chengeHexToDataWithString:str withType:300];
    return hexData;
}

//delete user
-(NSMutableData *)deleteUserWithNum:(NSString *)num
{
    NSString *hexStr = [FFTool ToHex:self.index];
    self.index++;
    NSString *seqStr =[HexTool create32HexStartWith80:hexStr];
    
    NSInteger zeroNum = 20 - num.length;
    NSMutableString *zeroStr = [NSMutableString string];
    for (int i=0;i<zeroNum;i++){
        [zeroStr appendString:@"0"];
    }
    
    NSString *numLengthHex = [FFTool ToHex:num.length];
    
    NSMutableData *cmdData = [[NSString stringWithFormat:@"%@%@",num,zeroStr] dataUsingEncoding:NSASCIIStringEncoding];
    NSString *dataStr = [FFTool dataToHexString:cmdData];
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
    
    NSString *imeiDataStr = [NSString stringWithFormat:@"%@,%@,%@",USER_MANAGERID_DELUSER,numLengthHex,dataString];
    
    
    NSString *cmdStr =[[NSString alloc]initWithFormat:@"%@,%@,%@,%@",USER_GROUPID,USER_COMMANDID,seqStr,imeiDataStr];
    
    NSArray *oxs = [cmdStr componentsSeparatedByString:@","];
    Byte bytes[oxs.count];
    for (int i = 0; i < oxs.count; i++) {
        const char *s = [oxs[i] UTF8String];
        Byte byte = (Byte)strtol(s, NULL, 16);
        bytes[i] = byte;
    }
    uint mybyte2=[GetCRC getCRCWith:bytes :28];
    
    NSString *cmdStr3 = [FFTool arrayChangeToString:oxs withSplit:@""];
    
    NSString *str = [NSString stringWithFormat:@"434F23%@%04x5741",cmdStr3,mybyte2];
    
    NSMutableData *hexData=[FFTool chengeHexToDataWithString:str withType:300];
    return hexData;

}

//飞行模式
-(NSMutableData *)flyMode
{
    NSString *hexStr = [FFTool ToHex:self.index];
    self.index++;
    NSString *seqStr =[HexTool create32HexStartWith80:hexStr];
    
    NSString *cmdStr =[[NSString alloc]initWithFormat:@"03,21,%@",seqStr];
    
    NSArray *oxs = [cmdStr componentsSeparatedByString:@","];
    Byte bytes[oxs.count];
    for (int i = 0; i < oxs.count; i++) {
        const char *s = [oxs[i] UTF8String];
        Byte byte = (Byte)strtol(s, NULL, 16);
        bytes[i] = byte;
    }
    uint mybyte2=[GetCRC getCRCWith:bytes :6];
    
    NSString *cmdStr3 = [FFTool arrayChangeToString:oxs withSplit:@""];
    
    NSString *str = [NSString stringWithFormat:@"434F0D%@%04x5741",cmdStr3,mybyte2];
    
    NSMutableData *hexData=[FFTool chengeHexToDataWithString:str withType:300];
    return hexData;
}

//跟随距离设置
-(NSMutableData *)followDistanceSetWithValueStr:(NSString *)valueStr lenght:(int)length
{
    NSString *hexStr = [FFTool ToHex:self.index];
    self.index++;
    NSString *seqStr =[HexTool create32HexStartWith80:hexStr];
    
    NSString *cmdStr =[[NSString alloc]initWithFormat:@"03,22,%@,%@",seqStr,valueStr];
    
    NSArray *oxs = [cmdStr componentsSeparatedByString:@","];
    Byte bytes[oxs.count];
    for (int i = 0; i < oxs.count; i++) {
        const char *s = [oxs[i] UTF8String];
        Byte byte = (Byte)strtol(s, NULL, 16);
        bytes[i] = byte;
    }
    uint mybyte2=[GetCRC getCRCWith:bytes :6+length];
    
    NSString *cmdStr3 = [FFTool arrayChangeToString:oxs withSplit:@""];
    
    NSString *cmdLength = [FFTool ToHex:13+length];
    
    NSString *str = [NSString stringWithFormat:@"434F%@%@%04x5741",cmdLength,cmdStr3,mybyte2];
    
    NSMutableData *hexData=[FFTool chengeHexToDataWithString:str withType:300];
    return hexData;
}

//报警距离设置
-(NSMutableData *)alertDistanceSetWithValueStr:(NSString *)valueStr lenght:(int)length
{
    NSString *hexStr = [FFTool ToHex:self.index];
    self.index++;
    NSString *seqStr =[HexTool create32HexStartWith80:hexStr];
    
    NSString *cmdStr =[[NSString alloc]initWithFormat:@"03,23,%@,%@",seqStr,valueStr];
    
    NSArray *oxs = [cmdStr componentsSeparatedByString:@","];
    Byte bytes[oxs.count];
    for (int i = 0; i < oxs.count; i++) {
        const char *s = [oxs[i] UTF8String];
        Byte byte = (Byte)strtol(s, NULL, 16);
        bytes[i] = byte;
    }
    uint mybyte2=[GetCRC getCRCWith:bytes :6+length];
    
    NSString *cmdStr3 = [FFTool arrayChangeToString:oxs withSplit:@""];
    
    NSString *cmdLength = [FFTool ToHex:13+length];
    
    NSString *str = [NSString stringWithFormat:@"434F%@%@%04x5741",cmdLength,cmdStr3,mybyte2];
    
    NSMutableData *hexData=[FFTool chengeHexToDataWithString:str withType:300];
    return hexData;
}

@end
