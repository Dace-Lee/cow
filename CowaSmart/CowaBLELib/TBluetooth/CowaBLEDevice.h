//
//  CowaBLEDevice.h
//  CowaBLE
//
//  Created by MX on 2016/10/31.
//  Copyright © 2016年 mx. All rights reserved.
//

#import <Foundation/Foundation.h>
#define timerGap 2
@class TBLEDevice, TBLEDeviceDistance, TBLEDeviceStatus;

@interface CowaBLEDevice : NSObject
@property (nonatomic, retain) TBLEDevice *device;
@property (nonatomic, retain) TBLEDeviceDistance *distanceTool;
@property (nonatomic, retain) TBLEDeviceStatus *status;
@property (nonatomic, assign) BOOL distanceSensor;
@property (nonatomic, assign) BOOL distanceSwith;
@property (nonatomic, assign) BOOL distanceAlarm;
@property (nonatomic, assign) BOOL heartbeat;
@property (nonatomic, assign) BOOL batteryLowAlarm;

- (id)initWithDevice:(TBLEDevice *)device;

- (void)setup;

@end
