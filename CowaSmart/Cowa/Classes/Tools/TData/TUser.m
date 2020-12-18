//
//  TUser.m
//  Cowa
//
//  Created by MX on 2016/11/2.
//  Copyright © 2016年 MX. All rights reserved.
//

#import "TUser.h"
#define Save(key, value) if (!value) { return; }\
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];[[NSUserDefaults standardUserDefaults] synchronize];
#define Get(key) id value = [[NSUserDefaults standardUserDefaults] valueForKey:key];            \
    return value == nil ? @"" : (NSString *)value;
#define ValueFor(key) [[NSUserDefaults standardUserDefaults] valueForKey:key];

@implementation TUser

+ (void)UserName:(NSString *)userName {
    Save(@"UserName", userName)
}

+ (void)UserPwd:(NSString *)userPwd {
    Save(@"UserPwd", userPwd)
}

+ (void)UserToken:(NSString *)userToken {
    Save(@"UserToken", userToken)
}

+ (void)UserNickName:(NSString *)userNickName {
    Save(@"UserNickName", userNickName)
}

+ (void)UserPhone:(NSString *)userPhone {
    Save(@"UserPhone", userPhone)
}

+ (void)sessionToken:(NSString *)token
{
    Save(@"sessionToken", token)
}

+ (void)breathLight:(NSString *)color
{
    Save(@"light", color)
}

+ (void)appVersion:(NSString *)version
{
    Save(@"version", version)
}

+ (void)boxName:(NSString *)name
{
    Save(@"boxName", name)
}

+ (void)imei:(NSString *)imei
{
    Save(@"imei", imei)
}
    
+ (void)lastPeripheralUUID:(NSString *)uuid {
    Save(@"lastUUID", uuid);
}
    
+ (NSString *)lastUUID {
    Get(@"lastUUID");
}

+ (NSString *)sessionToken
{
    Get(@"sessionToken")
}


+ (NSString *)UserName {
    Get(@"UserName")
}

+ (NSString *)UserPwd {
    Get(@"UserPwd")
}

+ (NSString *)UserToken {
    Get(@"UserToken")
}

+ (NSString *)UserNickName {
    Get(@"UserNickName")
}

+ (NSString *)UserPhone {
    Get(@"UserPhone")
}

+ (NSString *)breathColor
{
    Get(@"light")
}

+ (NSString *)appVersion
{
    Get(@"version")
}

+ (NSString *)boxName
{
    Get(@"boxName")
}

+ (NSString *)imei
{
    Get(@"imei")
}

+ (void)UseCelsius:(BOOL)Celsius {
    Save(@"UseCelsius", @(Celsius))
}

+ (BOOL)UseCelsius {
    id Celsius = ValueFor(@"UseCelsius")
    if (!Celsius) { return YES; }
    return [(NSNumber *)Celsius boolValue];
}

+ (void)UseBLESensor:(BOOL)sensor {
    Save(@"UseBLESensor", @(sensor))
}

+ (BOOL)UseBLESensor {
    id UseBLESensor = ValueFor(@"UseBLESensor")
    if (!UseBLESensor) { return NO; }
    return [(NSNumber *)UseBLESensor boolValue];
}

+ (void)UseAlarm:(BOOL)alarm {
    Save(@"UseAlarm", @(alarm))
}

+ (BOOL)UseAlarm {
    id UseAlarm = ValueFor(@"UseAlarm")
    if (!UseAlarm) { return NO; }
    return [(NSNumber *)UseAlarm boolValue];
}

//是否打开呼吸灯了
+ (void)UseLight:(BOOL)light
{
    Save(@"UseLight", @(light))
}

+ (BOOL)UseLight
{
    id UseLight = ValueFor(@"UseLight")
    if (!UseLight) { return NO; }
    return [(NSNumber *)UseLight boolValue];
}

//是否是host
+ (void)isHost:(BOOL)host;
{
    Save(@"isHost", @(host))
}

+ (BOOL)isHost
{
    id Celsius = ValueFor(@"isHost")
    if (!Celsius) { return YES; }
    return [(NSNumber *)Celsius boolValue];
}

@end
