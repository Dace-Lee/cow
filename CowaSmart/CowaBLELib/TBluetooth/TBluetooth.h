//
//  TBluetooth.h
//  Cowa
//
//  Created by MX on 16/5/9.
//  Copyright © 2016年 MX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TBLEDevice.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface TBluetooth : NSObject
@property (nonatomic, assign) BOOL BLEAvaliable;
@property (nonatomic,retain) NSMutableDictionary <CBPeripheral *, TBLEDevice *> *devices;
@property (nonatomic,retain)NSMutableArray *reConnectPeris;
@property (nonatomic,retain)CBCentralManager *centralManager;
@property (nonatomic,retain)CBPeripheral *peripheral;
@property(nonatomic,strong)NSTimer * timer;

@property (nonatomic,retain)NSUUID *identify;
@property (nonatomic,retain)CBService *cmdService;
@property (nonatomic,retain)CBService *dataService;
@property (nonatomic,retain)CBCharacteristic *cmdCha;
@property (nonatomic,retain)CBCharacteristic *cmdNotiCha;
@property (nonatomic,retain)CBCharacteristic *dataCha;
@property (nonatomic,retain)CBCharacteristic *dataNotiCha;


+ (instancetype)shareBluetooth;

- (void)startScan;
- (void)stopScan;
- (void)connectTo:(CBPeripheral *)peri;
- (void)cancelConnect:(CBPeripheral *)peri;
- (void)cancelAllPeConnect;
- (void)cancelReconnect:(CBPeripheral *)peri;
- (void)addReconnect:(CBPeripheral *)peri;
- (void)removeNotConnectDevices;


@end


