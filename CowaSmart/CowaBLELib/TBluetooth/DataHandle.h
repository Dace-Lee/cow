//
//  DataHandle.h
//  CowaBLE
//
//  Created by gaojun on 2017/9/13.
//  Copyright © 2017年 mx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataHandle : NSObject
{
    NSData *_lastData;
}

@property(assign,nonatomic)int index;
@property(assign,nonatomic)int fileIndex;
@property(nonatomic,copy)NSString *returnStr;

+(DataHandle *)sharedInstance;
//心跳包
-(NSMutableData *)sendHeartBeat;
//CMD
-(NSMutableData *)writeWithType:(int)type withFloatX:(float)x FloatY:(float)y ssid:(NSString *)ssid pwd:(NSString *)pwd;
//传输文件之前首先先发送类型指令
-(NSData *)sendFileDataWithName:(NSString *)name AndSize:(NSUInteger)size Type:(NSString *)type MD5Str:(NSString *)md5;
//传输数据
-(NSData *)sendFileData:(NSData *)data Type:(NSString *)type;
//上传上一次数据
-(NSData *)sendLastData;
//发送结束EOT
-(NSData *)sendEOTWithData;

//获取version
-(NSMutableData *)getVersion;
//获取imei
-(NSMutableData *)getImei;
//获取host
-(NSMutableData *)getHost;
//申请授权
-(NSMutableData *)authWithNum:(NSString *)num;
//绑定手环
-(NSMutableData *)bindHandleWith:(NSString *)num;
//reset
-(NSMutableData *)reset;
//add user
-(NSMutableData *)addUserWithNum:(NSString *)num;
//delete user
-(NSMutableData *)deleteUserWithNum:(NSString *)num;
//飞行模式
-(NSMutableData *)flyMode;
//跟随距离设置
-(NSMutableData *)followDistanceSetWithValueStr:(NSString *)valueStr lenght:(int)length;
//报警距离设置
-(NSMutableData *)alertDistanceSetWithValueStr:(NSString *)valueStr lenght:(int)length;

@end
