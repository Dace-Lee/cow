//
//  TBLEDeviceStatus.m
//  Cowa
//
//  Created by MX on 16/9/13.
//  Copyright © 2016年 MX. All rights reserved.
//

#import "TBLEDeviceStatus.h"
#import "TBLEDevice.h"
#import "TBLEDefines.h"
#import "TBLENotification.h"
#import "TBLEDeviceHelper.h"
#import <objc/runtime.h>
#import "AppDelegate.h"
#import "CowaBLEDevice.h"
#import "TBluetooth.h"
#import "DataHandle.h"
#import "FFTool.h"
#import "GJDevice.h"
#import <AudioToolbox/AudioToolbox.h>

@interface TBLEDeviceStatus()
{
    NSTimer *_hostSearchTimer;
    NSTimer *_addUserTimer;
    NSTimer *_deleteUserTimer;
    NSTimer *_authTimer;
    NSTimer *_imeiTimer;
    NSTimer *_bagVersionTimer;
    NSTimer *_authWithHostNumTimer;
    NSTimer *_authBackHostTimer;
    NSTimer *_addBackHostTimer;
    NSTimer *_authBoxHostTimer;
    NSTimer *_deleteBoxHostTimer;
}
@property (nonatomic, strong) NSData *response;
@end

@implementation TBLEDeviceStatus


- (id)init {
    if (self = [super init]) {
        self.misLock = NO;
        self.mSecLock = NO;
        self.isLockWrong = NO;
        self.followStatus = NO;
        self.isFollowWraning = NO;
        self.battery = 0;
        self.mileage = 0;
        self.speed = 0;
        self.isUpdating = NO;
        
        self.deleteUser = NO;
        self.hasReVersion = NO;
        self.hasReHost = NO;
        self.hasReAddUser = NO;
        self.hasReDeleteUser = NO;
        self.hasReAuth = NO;
        self.hasReImei = NO;
        self.hasReAuthWithBoxHostNum = NO;
        self.hasReDeleteBoxHost = NO;
        self.hasReAuthBackHost = NO;
        self.hasReAddBackHost = NO;
        self.hasReAuthBoxHost = NO;
        
        self.mode = @"";
        self.modeCode = @"";
    }
    return self;
}

//心跳包
- (void)getState
{
    NSMutableData *data = [[DataHandle sharedInstance] sendHeartBeat];
    [self.device send:data];
}

- (void)dealloc {
    [self removeObserver:self.device];
}

- (void)powerOff {
    NSMutableData *data = [[DataHandle sharedInstance] flyMode];
    [self.device send:data];
}

- (void)setLockM:(BOOL)swi {
    
    if (swi){
        NSMutableData *data = [[DataHandle sharedInstance] writeWithType:MAIN_LOCK_CLOSE withFloatX:0.0 FloatY:0.0 ssid:nil pwd:nil];
        [self.device send:data];
    }else{
        NSMutableData *data = [[DataHandle sharedInstance] writeWithType:MAIN_LOCK_OPEN withFloatX:0.0 FloatY:0.0 ssid:nil pwd:nil];
        [self.device send:data];
    }
    
}

//跟随状态
-(void)setFollow:(BOOL)swi
{
    if (swi){
        NSMutableData *data = [[DataHandle sharedInstance] writeWithType:MANNAL_OPEN withFloatX:0.0 FloatY:0.0 ssid:nil pwd:nil];
        [self.device send:data];
    }else{
        NSMutableData *data = [[DataHandle sharedInstance] writeWithType:MANNAL_CLOSE withFloatX:0.0 FloatY:0.0 ssid:nil pwd:nil];
        [self.device send:data];
    }
}

//跟随距离设置
-(void)followDistanceSetWithValue:(int)value
{
    NSString *valueStr = [FFTool ToHex:value];
    if (valueStr.length == 3){
        valueStr = [NSString stringWithFormat:@"0%@",valueStr];
    }
    
    NSString *valueString = [FFTool convertString:valueStr withSlipt:@","];
    
    NSArray *array = [valueString componentsSeparatedByString:@","];
    
    NSMutableData *data = [[DataHandle sharedInstance] followDistanceSetWithValueStr:valueString lenght:array.count];
    [self.device send:data];
}

//报警距离设置
-(void)alertDistanceSetWithValue:(int)value
{
    NSString *valueStr = [FFTool ToHex:value];
    if (valueStr.length == 3){
        valueStr = [NSString stringWithFormat:@"0%@",valueStr];
    }
    
    NSString *valueString = [FFTool convertString:valueStr withSlipt:@","];
    
    NSArray *array = [valueString componentsSeparatedByString:@","];
    
    NSMutableData *data = [[DataHandle sharedInstance] alertDistanceSetWithValueStr:valueString lenght:array.count];
    [self.device send:data];
}


- (void)setBreath:(TBLEDeviceBreathLEDColor)color {
   
    if (color == 0){
        NSMutableData *data = [[DataHandle sharedInstance] writeWithType:LAMP_SET_CLOSE withFloatX:0.0 FloatY:0.0 ssid:nil pwd:nil];
        [self.device send:data];
        
    }else if (color == 1){
        NSMutableData *data = [[DataHandle sharedInstance] writeWithType:LAMP_SET_RED withFloatX:0.0 FloatY:0.0 ssid:nil pwd:nil];
        [self.device send:data];
        
    }else if (color == 2){
        NSMutableData *data = [[DataHandle sharedInstance] writeWithType:LAMP_SET_GREEN withFloatX:0.0 FloatY:0.0 ssid:nil pwd:nil];
        [self.device send:data];
       
    }else if (color == 3){
       
        NSMutableData *data = [[DataHandle sharedInstance] writeWithType:LAMP_SET_BLUE withFloatX:0.0 FloatY:0.0 ssid:nil pwd:nil];
        [self.device send:data];
    }
    
}

//读取箱子版本
-(void)readBagVersion
{
    if(_bagVersionTimer==nil)
    {
        _bagVersionTimer=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(readVersion) userInfo:nil repeats:YES];
    }
}

-(void)readVersion
{
    NSMutableData *data = [[DataHandle sharedInstance] getVersion];
    NSLog(@"%@", [NSString stringWithFormat:@"status readVersion %@" ,data]);
    [self.device send:data];
}

//查询host
-(void)searchHost
{
    if(_hostSearchTimer==nil)
    {
        _hostSearchTimer=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(hostSearch) userInfo:nil repeats:YES];
    }
    
}

-(void)hostSearch
{
    NSMutableData *data = [[DataHandle sharedInstance] getHost];
    NSLog(@"%@", [NSString stringWithFormat:@"status hostSearch %@" ,data]);
    [self.device send:data];
}

//添加用户
-(void)addUserWithNum:(NSString *)num
{
    if(_addUserTimer==nil)
    {
        _addUserTimer=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(addUser:) userInfo:num repeats:YES];
    }
}

-(void)addUser:(NSTimer *)timer
{
    NSMutableData *data = [[DataHandle sharedInstance] addUserWithNum:timer.userInfo];
    [self.device send:data];
}

//删除用户
-(void)deleteUserWithNum:(NSString *)num
{
    if(_deleteUserTimer==nil)
    {
        _deleteUserTimer=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(delUser:) userInfo:num repeats:YES];
    }

}

-(void)delUserWithNum:(NSString *)num
{
    if (!self.deleteUser){
        self.deleteUser = YES;
        
        NSMutableData *data = [[DataHandle sharedInstance] deleteUserWithNum:num];
        [self.device send:data];
    }
    
}

-(void)delUser:(NSTimer *)timer
{
    NSMutableData *data = [[DataHandle sharedInstance] deleteUserWithNum:timer.userInfo];
    [self.device send:data];
}

//数据不一致时候，后台host与箱子host不相同，将箱子host删掉，把后台host刷进箱子
-(void)authWithBoxHostNum:(NSString *)num
{
    if(_authBoxHostTimer==nil)
    {
        _authBoxHostTimer=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(auth:) userInfo:num repeats:YES];
    }
}

-(void)deleteBoxHostNum:(NSString *)num
{
    if(_deleteBoxHostTimer==nil)
    {
        _deleteBoxHostTimer=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(delUser:) userInfo:num repeats:YES];
    }
}

//检测Auth
-(void)authWithNum:(NSString *)num
{
    if(_authTimer==nil)
    {
        _authTimer=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(auth:) userInfo:num repeats:YES];
    }
}

-(void)auth:(NSTimer *)timer
{
    NSMutableData *data = [[DataHandle sharedInstance] authWithNum:timer.userInfo];
    [self.device send:data];
}

//用箱子上的host 检测auth
-(void)authWithHostNum:(NSString *)num
{
    if(_authWithHostNumTimer==nil)
    {
        _authWithHostNumTimer=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(auth:) userInfo:num repeats:YES];
    }
}

//数据不一致时候，箱子没有host，将后台host刷进箱子
-(void)authWithBackHostNum:(NSString *)num
{
    if(_authBackHostTimer==nil)
    {
        _authBackHostTimer=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(auth:) userInfo:num repeats:YES];
    }
}

-(void)addBackHostWithNum:(NSString *)num
{
    if(_addBackHostTimer==nil)
    {
        _addBackHostTimer=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(addUser:) userInfo:num repeats:YES];
    }
}

//获取imei
-(void)getImei
{
    if(_imeiTimer==nil)
    {
        _imeiTimer=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(startGetImei) userInfo:nil repeats:YES];
    }
}

-(void)startGetImei
{
    NSMutableData *data = [[DataHandle sharedInstance] getImei];
    NSLog(@"%@", [NSString stringWithFormat:@"status startGetImei %@" ,data]);
    [self.device send:data];
}

//reset指令
-(void)sendReset
{
    NSMutableData *data = [[DataHandle sharedInstance] reset];
    [self.device send:data];
}

//修改设备名和密码
-(void)changePerNameAndPwdWithName:(NSString *)name
{
    NSString *nameCmd = [NSString stringWithFormat:@"AT+NAME CR %@",name];
    NSData *nameData = [nameCmd dataUsingEncoding:NSUTF8StringEncoding];

    [self.device setDeviceNameAndPwdWithData:nameData];
    
}

//手环绑定
-(void)bindHandleRingWithNum:(NSString *)num{
    NSMutableData *data = [[DataHandle sharedInstance] bindHandleWith:num];
    [self.device send:data];
}

//遥控箱子
-(void)remoteControlWithFloatX:(float)x FloatY:(float)y{
    NSMutableData *data = [[DataHandle sharedInstance] writeWithType:MOVE_CMD withFloatX:x FloatY:y ssid:nil pwd:nil];
    [self.device send:data];
}

//降下轮子
-(void)wheelDown{
    NSMutableData *data = [[DataHandle sharedInstance] writeWithType:WHEEL_DOWN withFloatX:0 FloatY:0 ssid:nil pwd:nil];
    [self.device send:data];
}

//升起轮子
-(void)wheelUp{
    NSMutableData *data = [[DataHandle sharedInstance] writeWithType:WHEEL_UP withFloatX:0 FloatY:0 ssid:nil pwd:nil];
    [self.device send:data];
}

/*
 *升级
 */
-(void)sendPreData:(NSData *)data MD5Str:(NSString *)md5{
    [GJDevice sharedInstance].index = 0;
    [GJDevice sharedInstance].fileIndex = 0;
    NSMutableData *data1 = [[GJDevice sharedInstance] sendFileDataWithName:@"" AndSize:data.length Type:@"" MD5Str:md5];
    [self.device send:data1];
}

-(void)sendData:(NSData *)data{
    NSData *data1 = [[GJDevice sharedInstance] sendFileData:data Type:@""];
    [self.device send:(NSMutableData *)data1];
}

-(void)sendLastData{
    NSData *data1 = [[GJDevice sharedInstance] sendLastData];
    [self.device send:(NSMutableData *)data1];
}

-(void)sendETO{
    NSData *data1 = [[GJDevice sharedInstance] sendEOTWithData];
    [self.device send:(NSMutableData *)data1];
}

-(void)judgeBagVersion
{
    if (_bagVersionTimer){
        [_bagVersionTimer invalidate];
        _bagVersionTimer = nil;
        
        if (!_hasReVersion){
            _hasReVersion = YES;
            
            NSString *versionLengthStr = [self.resContent substringWithRange:NSMakeRange(18, 22)];
            NSString *version = [FFTool stringFromHexString:versionLengthStr];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HasGetBoxVersion" object:version];
            
            [self searchHost];
        }
    }
    
}

-(void)judgeHost
{
    NSString *hostLengthStr = [self.resContent substringWithRange:NSMakeRange(20, 2)];
    
    NSString *host = [[NSString alloc] init];
    
    if ([hostLengthStr isEqualToString:@"00"]){
        //箱子上没有host
        host = @"";
        
    }else{
        //箱子上有host
        NSString * temp10 = [NSString stringWithFormat:@"%lu",strtoul([hostLengthStr UTF8String],0,16)];
        int hostLength = [temp10 intValue];
        
        NSString *hostHexStr = [self.resContent substringWithRange:NSMakeRange(22, hostLength*2)];
        host = [FFTool stringFromHexString:hostHexStr];
        
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HasGetBoxHost" object:host];
    
    [self getImei];
    
}

-(void)judgeAddUser
{
    NSString *addUserLengthStr = [self.resContent substringWithRange:NSMakeRange(20, 2)];
    
    if (![addUserLengthStr isEqualToString:@"00"]){
        
        if (_addUserTimer){
            
            [_addUserTimer invalidate];
            _addUserTimer = nil;
            
            if (!self.hasReAddUser){
                self.hasReAddUser = YES;
                
                //认证成功
                [[NSNotificationCenter defaultCenter] postNotificationName:@"boxAuthSuccess" object:nil userInfo:nil];
            }
            
        }
        
        if (_addBackHostTimer){
            
                
                [_addBackHostTimer invalidate];
                _addBackHostTimer=nil;
                
                
                if (!self.hasReAddBackHost){
                    self.hasReAddBackHost = YES;
                
                    
                    //前后台数据不一致，且后台有host情况下，箱子上host刷新完成
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"BoxHostNotEulToBackOver" object:nil];
 
            }
        }
    }
    
}

-(void)judgeDelUser
{
    NSString *deleteUserLengthStr = [self.resContent substringWithRange:NSMakeRange(20, 2)];
    
    if (![deleteUserLengthStr isEqualToString:@"00"]){
        
        if (self.deleteUser){
            
//            [_deleteUserTimer invalidate];
//            _deleteUserTimer = nil;
            
            self.deleteUser = NO;
            
        }
        
        
        if (_deleteBoxHostTimer){
                
            [_deleteBoxHostTimer invalidate];
            _deleteBoxHostTimer = nil;
                
                
                if (!self.hasReDeleteBoxHost){
                    self.hasReDeleteBoxHost = YES;
                   
                    
                    //数据不同步时，箱子上host删除结束，此时开始将后台host刷进箱子
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"HasDeleteBoxHostWhenNotSync" object:nil];
                    
                
                
            }
        }
    }
}

-(void)judgeAuth
{
    NSString *authLengthStr = [self.resContent substringWithRange:NSMakeRange(20, 2)];
    
    if (![authLengthStr isEqualToString:@"00"]){
        
        if (_authTimer){
            
            [_authTimer invalidate];
            _authTimer = nil;
            
            if (!self.hasReAuth){
                self.hasReAuth = YES;
                
                NSString * temp10 = [NSString stringWithFormat:@"%lu",strtoul([authLengthStr UTF8String],0,16)];
                int authLength = [temp10 intValue];
                
                NSString *authHexStr = [self.resContent substringWithRange:NSMakeRange(22, authLength*2)];
                NSString *auth = [FFTool stringFromHexString:authHexStr];
                
                [self addUserWithNum:auth];
            }
            
        }
        
        if (_authWithHostNumTimer){
            
            [_authWithHostNumTimer invalidate];
            _authWithHostNumTimer = nil;
            
            if (!self.hasReAuthWithBoxHostNum){
                self.hasReAuthWithBoxHostNum = YES;
                
                //通知添加当前用户
                [[NSNotificationCenter defaultCenter] postNotificationName:@"boxHostAuthOk" object:nil userInfo:nil];
            }
        }
        
        if (_authBackHostTimer){
            
            [_authBackHostTimer invalidate];
            _authBackHostTimer=nil;
                //授权成功
            if (!self.hasReAuthBackHost){
                self.hasReAuthBackHost = YES;
                
                NSString * temp10 = [NSString stringWithFormat:@"%lu",strtoul([authLengthStr UTF8String],0,16)];
                int authLength = [temp10 intValue];
                
                NSString *authHexStr = [self.resContent substringWithRange:NSMakeRange(22, authLength*2)];
                NSString *auth = [FFTool stringFromHexString:authHexStr];
                    
                [self addBackHostWithNum:auth];
                    
            }
        }
        
        if (_authBoxHostTimer){
                
            [_authBoxHostTimer invalidate];
            _authBoxHostTimer=nil;
                //授权成功
                if (!self.hasReAuthBoxHost){
                    self.hasReAuthBoxHost = YES;
                    
                    NSString * temp10 = [NSString stringWithFormat:@"%lu",strtoul([authLengthStr UTF8String],0,16)];
                    int authLength = [temp10 intValue];
                    
                    NSString *authHexStr = [self.resContent substringWithRange:NSMakeRange(22, authLength*2)];
                    NSString *auth = [FFTool stringFromHexString:authHexStr];
                    
                    [self deleteBoxHostNum:auth];
                    
                
                
            }
        }
        
    }

}

-(void)judgeImei
{
    NSString *imeiLengthStr = [self.resContent substringWithRange:NSMakeRange(20, 2)];
    
    if (![imeiLengthStr isEqualToString:@"00"]){
        
        if (_imeiTimer){
            [_imeiTimer invalidate];
            _imeiTimer = nil;
            
            if (!self.hasReImei){
                self.hasReImei = YES;
                
                NSString * temp10 = [NSString stringWithFormat:@"%lu",strtoul([imeiLengthStr UTF8String],0,16)];
                int imeiLength = [temp10 intValue];
                
                NSString *imeiHexStr = [self.resContent substringWithRange:NSMakeRange(22, imeiLength*2)];
                NSString *imei = [FFTool stringFromHexString:imeiHexStr];
                
                self.imeiString = imei;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"HasGetImei" object:imei];
                
            }
        }
        
    }
    
}

-(void)judgeReset
{
    
}

- (void)parseResponse {
    
    NSString *resContent = [FFTool dataToHexString:self.response];
    
    NSLog(@"response:%@",resContent);
    NSMutableString *dataStr2 = [NSMutableString stringWithString:resContent];
    [dataStr2 replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:NSMakeRange(0, dataStr2.length)];
    
    if (self.isUpdating){
        
        if (dataStr2.length > 21){
            NSLog(@"~~~rec1:%@",dataStr2);
            NSString *reStr = [dataStr2 substringWithRange:NSMakeRange(18, 2)];
            NSLog(@"%@",reStr);
            if ([reStr isEqualToString:@"06"]){
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"hasReceiveData" object:nil];
            }else if ([reStr isEqualToString:@"18"]){
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelUpdate" object:nil];
            }else if ([reStr isEqualToString:@"15"]){
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"aplySendDataAgain" object:nil];
            }
        }
        
    }else{
        
        if ([dataStr2 hasPrefix:START]&&[dataStr2 hasSuffix:END]){
            self.resContent = dataStr2;
            
            //NSLog(@"~~~rec2:%@",self.resContent);
            
            if (self.resContent) {
                
                //提取commandid
                if (self.resContent.length > 11){
                    NSString *commandid = [self.resContent substringWithRange:NSMakeRange(8, 2)];
                    
                    if ([commandid isEqualToString:ACK_USER_COMMANDID]){
                        [self parseUserData];
                    }else if ([commandid isEqualToString:ACK_OPRATION_COMMANDID]){
                        [self parseOperationData];
                    }else if ([commandid isEqualToString:ACK_HEARTBEAT_COMMANDID]){
                        [self parseHeartBeatData];
                    }else if ([commandid isEqualToString:ACK_VERSION_COMMANDID]){
                        [self judgeBagVersion];
                    }
                }
            }
        }
    }
}

-(void)parseUserData
{
    //提取managerid
    NSString *managerid = [self.resContent substringWithRange:NSMakeRange(18, 2)];
    //NSLog(@"*******%@",managerid);
    
    if ([managerid isEqualToString:USER_MANAGERID_IMEI]){

        [self judgeImei];
        
    }else if ([managerid isEqualToString:USER_MANAGERID_HOST]){
        
        if (!self.hasReHost) {
            self.hasReHost = YES;
            
            [_hostSearchTimer invalidate];
            _hostSearchTimer = nil;
            
            [self judgeHost];
        }
        
    }else if ([managerid isEqualToString:USER_MANAGERID_AUTH]){
        
        [self judgeAuth];
        
    }else if ([managerid isEqualToString:USER_MANAGERID_ADDUSER]){
        
        [self judgeAddUser];
        
    }else if ([managerid isEqualToString:USER_MANAGERID_DELUSER]){
        
        [self judgeDelUser];
        
    }else if ([managerid isEqualToString:USER_MANAGERID_RESET]){
        
        [self judgeReset];
        
    }
}

-(void)parseOperationData
{
    
}

-(void)parseHeartBeatData
{
    [self parseErrorMode];
    
    //解析主锁
    NSString *lockStr = [self.resContent substringWithRange:NSMakeRange(18, 4)];
    NSString *lockString = [FFTool convertString:lockStr withSlipt:@""];
    unsigned long long status = 0;
    [self transferHexStr:&status str:lockString];
    
    self.misLock = ((status & 0xF) & 0x01);
    //NSLog(@"%d",self.misLock);
    self.mSecLock = ((( status >> 2 ) & 0xF ) & 0x01 );
    //NSLog(@"%d",self.mSecLock);
    self.isLockWrong = ((( status >> 6 ) & 0xF ) & 0x01 );
    //NSLog(@"%d",self.isLockWrong);
    
    //解析电量
    NSString *capcityString = [self.resContent substringWithRange:NSMakeRange(22, 2)];
    UInt64 mac1 =  strtoul([capcityString UTF8String], 0, 16);
    self.battery = (NSUInteger)mac1;

    //解析里程
    NSString *mileageStr = [self.resContent substringWithRange:NSMakeRange(32, 8)];
    NSString *mileageString = [FFTool convertString:mileageStr withSlipt:@""];
    unsigned long long mileageStatus = 0;
    [self transferHexStr:&mileageStatus str:mileageString];

    unsigned long long mileage = mileageStatus & 0xFFFFFFFF;
    self.mileage = (NSUInteger)mileage;

    //解析速度
    NSString *speedStr = [self.resContent substringWithRange:NSMakeRange(48, 4)];
    NSString *speedString = [FFTool convertString:speedStr withSlipt:@""];
    //NSLog(@"%@",speedString);
    unsigned long long speedStatus = 0;
    [self transferHexStr:&speedStatus str:speedString];

    unsigned long long speed = speedStatus & 0xFFFF;
    self.speed = (NSUInteger)speed;

    //解析跟随状态
    NSString *followStr = [self.resContent substringWithRange:NSMakeRange(28, 4)];
    NSString *followString = [FFTool convertString:followStr withSlipt:@""];
    
    unsigned long long followStatus = 0;
    [self transferHexStr:&followStatus str:followString];

    self.followStatus = (( followStatus & 0xF ) & 0x01) && ((( followStatus >> 1) & 0xF ) & 0x01);
    if ([followString isEqualToString:@"0205"]) {
        self.isFollowWraning = YES;
        self.followStatus = YES;
    }else{
        self.isFollowWraning = NO;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kBLENotiStatusUpdate object:nil userInfo:nil];
}

-(void)parseErrorMode{
    //解析R1状态
    NSString *r1State = [self.resContent substringWithRange:NSMakeRange(28, 4)];
    NSString *r1StateString = [FFTool convertString:r1State withSlipt:@""];
    unsigned long long r1StateStatus = 0;
    [self transferHexStr:&r1StateStatus str:r1StateString];
    
    if ((r1StateStatus & 0x01) && ((r1StateStatus >> 2) & 0x01)){
        self.mode = @"警告模式";
        
        BOOL six = ((r1StateStatus >> 6) & 0x01);
        BOOL seven = ((r1StateStatus >> 7) & 0x01);
        BOOL eight = ((r1StateStatus >> 8) & 0x01);
        
        if (!six && seven && !eight){
            self.modeCode = @"请为手环充电";
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showErrorView" object:nil];
        }
        if ((!six && !seven && eight) || (six && !seven && eight) || (!six && seven && eight)) {
            self.modeCode = @"请重新开启跟随功能";
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showErrorView" object:nil];
        }
    }
    
    if (((r1StateStatus >> 1) & 0x01) && ((r1StateStatus >> 2) & 0x01)){
        self.mode = @"错误模式";
        
        BOOL eleven = ((r1StateStatus >> 11) & 0x01);
        BOOL twelve = ((r1StateStatus >> 12) & 0x01);
        BOOL thirteen = ((r1StateStatus >> 13) & 0x01);
        BOOL fourteen = ((r1StateStatus >> 14) & 0x01);
        
        if ((eleven && !twelve && !thirteen && !fourteen) || (!eleven && twelve && !thirteen && !fourteen) || (eleven && twelve && !thirteen && !fourteen) || (!eleven && !twelve && !thirteen && fourteen) || (!eleven && !twelve && thirteen && fourteen)){
            self.modeCode = @"请关机3分钟后重新启动";
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showErrorView" object:nil];
        }
        if ((!eleven && !twelve && thirteen && !fourteen) || (!eleven && twelve && !thirteen && fourteen) || (eleven && twelve && !thirteen && fourteen)){
            self.modeCode = @"请联系客服";
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showErrorView" object:nil];
        }
        
        
     }
}



#pragma mark - private methods
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([object isEqual:self.device] && [keyPath isEqualToString:@"response"]) {
        @try {
            [self setResponse:(NSData *)[change objectForKey:@"new"]];
        } @catch (NSException *exception) {
            //NSLog(@"KVO-Error:%@", exception);
        } @finally {}
    }else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)transferHexStr:(unsigned long long *)num str:(NSString *)str {
    NSScanner *scanner = [NSScanner scannerWithString:str];
    [scanner setScanLocation:0];
    [scanner scanHexLongLong:num];
}

- (void)addObserver:(TBLEDevice *)obj {
    [obj addObserver:self forKeyPath:@"response" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserver:(TBLEDevice *)obj {
    @try {
        [obj removeObserver:self forKeyPath:@"response"];
    } @catch (NSException *exception) {
    } @finally {}
}

#pragma mark - setter
- (void)setResponse:(NSData *)response {
    _response = response;
    [self parseResponse];
}

- (void)setDevice:(TBLEDevice *)device {
    TBLEDevice *lastDevice = _device;
    _device = device;
    if (![lastDevice isEqual:_device]) {
        [self removeObserver:lastDevice];
        [self addObserver:_device];
    }
}


@end
