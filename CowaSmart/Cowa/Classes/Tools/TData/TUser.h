//
//  TUser.h
//  Cowa
//
//  Created by MX on 2016/11/2.
//  Copyright © 2016年 MX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TUser : NSObject
///如果参数为空会直接return
+ (void)UserName:(NSString *)userName;
+ (void)UserPwd:(NSString *)userPwd;
///会自动在token前面加上Bearer 
+ (void)UserToken:(NSString *)userToken;
+ (void)UserNickName:(NSString *)userNickName;
+ (void)UserPhone:(NSString *)userPhone;
+ (void)sessionToken:(NSString *)token;
+ (void)breathLight:(NSString *)color;
+ (void)appVersion:(NSString *)version;
+ (void)boxName:(NSString *)name;
+ (void)imei:(NSString *)imei;
+ (void)lastPeripheralUUID:(NSString *)uuid;

///如果没有数据返回空字符串
+ (NSString *)UserName;
+ (NSString *)UserPwd;
+ (NSString *)UserToken;
+ (NSString *)UserNickName;
+ (NSString *)UserPhone;
+ (NSString *)sessionToken;
+ (NSString *)breathColor;
+ (NSString *)appVersion;
+ (NSString *)boxName;
+ (NSString *)imei;
+ (NSString *)lastUUID;

///使用摄氏温度
+ (void)UseCelsius:(BOOL)Celsius;
+ (BOOL)UseCelsius;

///是否打开距离感应开关，默认关
+ (void)UseBLESensor:(BOOL)sensor;
+ (BOOL)UseBLESensor;

///是否打开提醒
+ (void)UseAlarm:(BOOL)alarm;
+ (BOOL)UseAlarm;

//是否打开呼吸灯了
+ (void)UseLight:(BOOL)light;
+ (BOOL)UseLight;

//是否是host
+ (void)isHost:(BOOL)host;
+ (BOOL)isHost;


@end
