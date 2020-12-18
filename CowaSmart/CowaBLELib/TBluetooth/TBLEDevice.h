//
//  TBLEDevice.h
//  Cowa
//
//  Created by MX on 16/8/8.
//  Copyright © 2016年 MX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

//设备可以负责设备数据的写入，状态更新等一系列针对一个设备的操作；同时可以保存设备的数据，处理特定事件的回调
@interface TBLEDevice : NSObject 
@property (nonatomic, strong) NSDictionary *advertiseData;
@property (nonatomic, strong) NSString *macAddress;
@property (nonatomic, strong) NSString *itendifyStr;
@property (nonatomic, strong) NSString *name;

@property (nonatomic, retain) NSOperationQueue *writeQueue;

@property (nonatomic, retain) CBPeripheral *peri;

@property (nonatomic, strong) NSNumber *RSSI;
@property (nonatomic, assign) BOOL isReady;
@property (nonatomic, assign) BOOL isConnect;
@property (nonatomic, assign) BOOL selected;

- (void)setConnect:(BOOL)connect;

- (void)judgeDeviceIsReady;


@end

@interface TBLEDevice (Command)

@property (nonatomic, retain) NSData *response;

- (BOOL)send:(NSMutableData *)data;
- (void)writeData:(NSMutableData *)data;
-(void)setDeviceNameAndPwdWithData:(NSData *)data;
-(void)deleteAllCommand;


@end
