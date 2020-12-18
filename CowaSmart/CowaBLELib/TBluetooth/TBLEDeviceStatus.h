//
//  TBLEDeviceStatus.h
//  Cowa
//
//  Created by MX on 16/9/13.
//  Copyright © 2016年 MX. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TBLEDevice;

typedef NS_ENUM(NSUInteger, TBLEDeviceBreathLEDColor) {
    TBLEDeviceBreathLEDColorClose = 0,
    TBLEDeviceBreathLEDColorRed = 1,
    TBLEDeviceBreathLEDColorGreen = 2,
    TBLEDeviceBreathLEDColorBlue = 3
};

@interface TBLEDeviceStatus : NSObject
@property (nonatomic, retain) TBLEDevice *device;
@property (nonatomic, strong) NSString *resContent;
@property (nonatomic, assign) BOOL misLock;
@property (nonatomic, assign) BOOL mSecLock;
@property (nonatomic, assign) BOOL isLockWrong;
//是否跟随
@property (nonatomic, assign) BOOL followStatus;
//是否跟随丢失
@property(nonatomic,assign)BOOL isFollowWraning;
//是否在进行升级
@property (nonatomic, assign) BOOL isUpdating;
@property (nonatomic, assign) NSUInteger battery;
@property (nonatomic, assign) NSUInteger mileage;
@property (nonatomic, assign) NSUInteger speed;

@property (nonatomic, assign) BOOL deleteUser;
@property (nonatomic, assign) BOOL hasReVersion;
@property (nonatomic, assign) BOOL hasReHost;
@property (nonatomic, assign) BOOL hasReAddUser;
@property (nonatomic, assign) BOOL hasReDeleteUser;
@property (nonatomic, assign) BOOL hasReAuth;
@property (nonatomic, assign) BOOL hasReImei;
@property (nonatomic, assign) BOOL hasReAuthWithBoxHostNum;
@property (nonatomic, assign) BOOL hasReDeleteBoxHost;
@property (nonatomic, assign) BOOL hasReAuthBackHost;
@property (nonatomic, assign) BOOL hasReAddBackHost;
@property (nonatomic, assign) BOOL hasReAuthBoxHost;

@property (nonatomic, strong) NSString *imeiString;

@property (nonatomic, strong) NSString *mode;
@property (nonatomic, strong) NSString *modeCode;

//读取箱子版本
-(void)readBagVersion;
//查询host
-(void)searchHost;
//添加用户
-(void)addUserWithNum:(NSString *)num;
//删除用户
-(void)deleteUserWithNum:(NSString *)num;
-(void)delUserWithNum:(NSString *)num;
//检测Auth
-(void)authWithNum:(NSString *)num;
//用箱子上的host 检测auth
-(void)authWithHostNum:(NSString *)num;
//获取imei
-(void)getImei;
//锁
- (void)setLockM:(BOOL)swi;
//跟随状态
-(void)setFollow:(BOOL)swi;
//呼吸灯
- (void)setBreath:(TBLEDeviceBreathLEDColor)color;
//心跳包
- (void)getState;
//飞行模式
- (void)powerOff;
//reset指令
-(void)sendReset;
//跟随距离设置
-(void)followDistanceSetWithValue:(int)value;
//报警距离设置
-(void)alertDistanceSetWithValue:(int)value;
//修改设备名和密码
-(void)changePerNameAndPwdWithName:(NSString *)name;
//手环绑定
-(void)bindHandleRingWithNum:(NSString *)num;
//遥控箱子
-(void)remoteControlWithFloatX:(float)x FloatY:(float)y;
//降下轮子
-(void)wheelDown;
//升起轮子
-(void)wheelUp;

//数据不一致时候，箱子没有host，将后台host刷进箱子
-(void)authWithBackHostNum:(NSString *)num;
-(void)addBackHostWithNum:(NSString *)num;
//数据不一致时候，后台host与箱子host不相同，将箱子host删掉，把后台host刷进箱子
-(void)authWithBoxHostNum:(NSString *)num;
-(void)deleteBoxHostNum:(NSString *)num;

/*
 *升级
 */
-(void)sendPreData:(NSData *)data MD5Str:(NSString *)md5;
-(void)sendData:(NSData *)data;
-(void)sendLastData;
-(void)sendETO;


@end
