//
//  CowaBLEDevice.m
//  CowaBLE
//
//  Created by MX on 2016/10/31.
//  Copyright © 2016年 mx. All rights reserved.
//

#import "CowaBLEDevice.h"
#import "TBLEDefines.h"
#import "TBLEDevice.h"
#import "TBLEDeviceStatus.h"
#import "TBLEDeviceDistance.h"
#import "TBLENotification.h"
#import "TBluetooth.h"

@interface CowaBLEDevice ()
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSTimer *rssitimer;
@end

@implementation CowaBLEDevice

- (id)initWithDevice:(TBLEDevice *)device {
    if (self = [super init]) {
        self.device = device;
        [self.status setDevice:device];
        [self.distanceTool setDevice:device];
        [self addListener];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"StartCheckAuth" object:nil];
        
        [self.status readBagVersion];

    }
    return self;
}

-(void)TheBagHasAuthSuccess
{
    [[TBluetooth shareBluetooth] addReconnect:self.device.peri];
    
    [self setup];
}

-(void)addListener
{
    [[ NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopStatus) name:@"hasDisconnect" object:nil];
    [[ NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TheBagHasAuthSuccess) name:@"TheBagHasAuthSuccess" object:nil];
    [[ NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopStatus) name:@"deleteUserSuccess" object:nil];
    [[ NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TheBagHasAuthSuccess) name:@"StartSendHeart" object:nil];
    [[ NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopStatus) name:@"stopSendStatus" object:nil];
    [[ NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userIsNotExist) name:@"userIsNotExist" object:nil];
    [[ NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopStatus) name:@"startUpdateFile" object:nil];
    [[ NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startStatus) name:@"stopUpdateFile" object:nil];
}

-(void)userIsNotExist{
    [self.timer invalidate];
    self.timer = nil;
    
    [self.rssitimer invalidate];
    self.rssitimer = nil;
    
    [self.status readBagVersion];
}

-(void)stopStatus
{
    [self.timer invalidate];
    self.timer = nil;
    
    [self.rssitimer invalidate];
    self.rssitimer = nil;
}

-(void)startStatus
{
    [self.timer fire];
    
    [self.rssitimer fire];
}

- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
    
    [self.rssitimer invalidate];
    self.rssitimer = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)setup {
    self.distanceSensor = YES;
    self.distanceSwith = NO;
    self.distanceAlarm = YES;//之前是NO，好像是从用户设置里面来的
    self.heartbeat = YES;
    self.batteryLowAlarm = NO;

    [self.timer fire];
    [self.rssitimer fire];


    weakify(self);
    self.distanceTool.distanceChanged = ^(double distance, distance_direction dir) {
        strongify(self);
        
        if (self.distanceSensor) {
            
//            if (self.distanceAlarm){
                if (far == dir){
                    [[NSNotificationCenter defaultCenter] postNotificationName:kCowaBLENotiDistanceFaraway object:nil];
                }else{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"kCowaBLENotiDistanceNear" object:nil];
                }
//            }
//
//            if (self.distanceSwith){
//                if (far == dir){
//
//                }else if (closer == dir){
//
//                }
//            }
            
        }
    };
}

#pragma mark - events
- (void)eTimer {
    if (self.heartbeat) {
        [self.status getState];
        
        if (self.batteryLowAlarm && self.status.battery <= 10) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kCowaBLENotiBatteryLow object:nil];
        }
    }
}

- (void)rssiTimer {
    if (self.distanceSensor) {
        [self.device.peri readRSSI];
    }
    
}

#pragma mark - setter

#pragma mark - getter
- (TBLEDeviceStatus *)status {
    if (!_status) {
        _status = [[TBLEDeviceStatus alloc] init];
    }
    return _status;
}

- (TBLEDeviceDistance *)distanceTool {
    if (!_distanceTool) {
        _distanceTool = [[TBLEDeviceDistance alloc] init];
    }
    return _distanceTool;
}

- (NSTimer *)timer {
    self.distanceSensor = YES;
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:0.2
                                                 target:self
                                               selector:@selector(eTimer)
                                               userInfo:nil
                                                repeats:YES];
        
        // 将定时器添加到运行循环
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

- (NSTimer *)rssitimer {
    if (!_rssitimer) {
        _rssitimer = [NSTimer timerWithTimeInterval:1.0
                                         target:self
                                       selector:@selector(rssiTimer)
                                       userInfo:nil
                                        repeats:YES];
        
        // 将定时器添加到运行循环
        [[NSRunLoop currentRunLoop] addTimer:_rssitimer forMode:NSRunLoopCommonModes];
    }
    return _rssitimer;
}

@end
