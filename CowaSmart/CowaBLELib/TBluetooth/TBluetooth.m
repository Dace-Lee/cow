//
//  TBluetooth.m
//  Cowa
//
//  Created by MX on 16/5/9.
//  Copyright © 2016年 MX. All rights reserved.
//

#import "TBluetooth.h"
#import "TBLEDefines.h"
#import "TBLENotification.h"
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface TBluetooth()<CBCentralManagerDelegate,CBPeripheralDelegate>

@end

@implementation TBluetooth


#pragma mark - life cycle
+ (instancetype)shareBluetooth {
    static id shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[[self class] alloc] init];
    });
    return shared;
}

- (id)init {
    if (self = [super init]) {
        
        self.centralManager = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
        self.reConnectPeris = [[NSMutableArray alloc]init];
        
    }
    return self;
}

- (void)startScan {
    
    NSArray *arr = [self.centralManager retrieveConnectedPeripheralsWithServices:@[[CBUUID UUIDWithString:ServiceUUID],[CBUUID UUIDWithString:DATA_SEVICE]]];
    if(arr.count>0){

        CBPeripheral *peripheral = [arr firstObject];
        if (peripheral != nil){
            [self cancelConnect:peripheral];
        }

    }
    
    [self.devices removeAllObjects];
        
    NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@NO};
    [self.centralManager scanForPeripheralsWithServices:nil options:scanForPeripheralsWithOptions];
    
    
}

- (void)stopScan {
    [self.centralManager stopScan];
}

- (void)connectTo:(CBPeripheral *)peri {
    
    if (!peri) { return; }
    
    if (peri.state == CBPeripheralStateDisconnected){
        NSDictionary *connectOptions = @{CBConnectPeripheralOptionNotifyOnConnectionKey:@YES,
                                         CBConnectPeripheralOptionNotifyOnDisconnectionKey:@YES,
                                         CBConnectPeripheralOptionNotifyOnNotificationKey:@NO};
        
        [self.centralManager connectPeripheral:peri options:connectOptions];
    
    }
    
}

- (void)cancelConnect:(CBPeripheral *)peri {
    [self.centralManager cancelPeripheralConnection:peri];
}

- (void)cancelAllPeConnect
{
    for(int i=0;i<self.devices.allKeys.count;i++){
        [self.centralManager cancelPeripheralConnection:self.devices.allKeys[i]];
    }
}

-(void)cancelReconnect:(CBPeripheral *)peri
{
    if ([self.reConnectPeris containsObject:peri]){
        [self.reConnectPeris removeObject:peri];
    }
}

-(void)addReconnect:(CBPeripheral *)peri
{
    if (![self.reConnectPeris containsObject:peri]){
        [self.reConnectPeris addObject:peri];
    }
}

- (void)removeNotConnectDevices {
    
    if (self.devices.count > 0){
        
        @try {
            [self.devices removeAllObjects];
        } @catch (NSException *exception) {
            
        } @finally {
           
        }
        
    }
}

//中央代理
-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
    case CBCentralManagerStatePoweredOff:
        [self.devices removeAllObjects];
        [[NSNotificationCenter defaultCenter] postNotificationName:kBluetoothNotiDeviceChanged object:nil];
        self.BLEAvaliable = NO;
        break;
    case CBCentralManagerStatePoweredOn:
        self.BLEAvaliable = YES;
        break;
    default:
        self.BLEAvaliable = NO;
        break;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kBluetoothNotiPowerChanged object:nil];
}


-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    if (![self.devices.allKeys containsObject:peripheral] && peripheral.name != nil) {
        TBLEDevice *aDevice = [[TBLEDevice alloc] init];
        [aDevice setValue:advertisementData forKey:@"advertiseData"];
        [aDevice setValue:peripheral forKey:@"peri"];
        NSString *pName = [[aDevice valueForKey:@"advertiseData"] valueForKey:@"kCBAdvDataLocalName"];
        
        if ([pName hasPrefix:@"COWA"]||[pName hasPrefix:@"CR "]){
            aDevice.name = pName;
            aDevice.itendifyStr = peripheral.identifier.UUIDString;
            [self.devices setObject:aDevice forKey:peripheral];
        }
        
        //判断搜索到的设备uuid是不是上次连接的uuid，如果是则隐藏扫描界面，扫描列表界面，直接连接；没有，则显示设备列表页面。
        NSLog(@"+++++++++++++++++%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"lastUUID"] );
        if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"lastUUID"] isEqualToString:@""] && [[[NSUserDefaults standardUserDefaults] valueForKey:@"lastUUID"] isEqualToString:peripheral.identifier.UUIDString]) {
            [self stopScan];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hasDiscoveLastDevice" object:nil];
            [self connectTo:peripheral];
            [[NSUserDefaults standardUserDefaults] setValue:pName forKey:@"boxName"];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kBluetoothNotiDeviceChanged object:nil];
    }
}

-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    if ([self.devices.allKeys containsObject:peripheral]) {
        self.peripheral = nil;
        self.peripheral = [peripheral copy];
        self.identify = peripheral.identifier;
        self.peripheral.delegate = self;
        [peripheral discoverServices:@[[CBUUID UUIDWithString:ServiceUUID],[CBUUID UUIDWithString:DATA_SEVICE]]];
        [self.devices[peripheral] setConnect:YES];//只是把isConnect赋值YES
        NSLog(@"{\"action\": \"connect success\",\"content\":\"%@\",\"time\":\"***\",\"Imei\":\"123456\"}",peripheral.name);
    }
}
-(void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(NSError *)error
{

    if ([self.devices.allKeys containsObject:peripheral]) {
        [self.devices[peripheral] setValue:RSSI forKey:@"RSSI"];
    }
}



-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    if ([self.devices.allKeys containsObject:peripheral]) {
        [self.devices[peripheral] deleteAllCommand];
        [self.devices[peripheral] setConnect:NO];
        NSLog(@"{\"action\": \"cancel connect\",\"content\":\"%@\",\"time\":\"***\",\"Imei\":\"123456\"}",peripheral.name);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hasDisconnect" object:nil];
        
        if ([self.reConnectPeris containsObject:peripheral]){
            [self.centralManager connectPeripheral:peripheral options:nil];
        }

    }
}

//外围代理
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{

    
    for (CBService *aService in self.peripheral.services) {
        if ([aService.UUID.UUIDString isEqualToString:ServiceUUID]) {
            self.cmdService = aService;
           
            [peripheral discoverCharacteristics:nil forService:self.cmdService];
        }else if ([aService.UUID.UUIDString isEqualToString:DATA_SEVICE]) {
            self.dataService = aService;
           
            [peripheral discoverCharacteristics:nil forService:self.dataService];
        }
    }
}


-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{

    
    if ([service.UUID.UUIDString isEqualToString:ServiceUUID]) {
        for (CBCharacteristic *cha in service.characteristics) {
            if ([cha.UUID.UUIDString isEqualToString:CharacteristicUUIDNotify]) {
                self.cmdNotiCha = cha;
                
               
               
                [peripheral setNotifyValue:YES forCharacteristic:self.cmdNotiCha];
                
            }else if ([cha.UUID.UUIDString isEqualToString:CharacteristicUUIDWrite]) {
                self.cmdCha = cha;
              
             
                [self.devices[peripheral] judgeDeviceIsReady];//开始发送指令
                
            }
            
        }
    }else if ([service.UUID.UUIDString isEqualToString:DATA_SEVICE]) {
        for (CBCharacteristic *cha in service.characteristics) {
            if ([cha.UUID.UUIDString isEqualToString:dataCharacteristicUUIDWrite]) {
                self.dataCha = cha;
              
            }else if ([cha.UUID.UUIDString isEqualToString:dataCharacteristicUUIDNotify]) {
                self.dataNotiCha = cha;
               
              
                [peripheral setNotifyValue:YES forCharacteristic:self.dataNotiCha];
            }
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error
{
    [peripheral readValueForCharacteristic:characteristic];
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
    if ([self.devices.allKeys containsObject:self.peripheral]) {
        TBLEDevice *dev = self.devices[peripheral];
        if ([characteristic.UUID.UUIDString isEqualToString:CharacteristicUUIDNotify] ||[characteristic.UUID.UUIDString isEqualToString:dataCharacteristicUUIDNotify]) {
            if (characteristic.value != nil) {
                [dev setValue:characteristic.value forKey:@"response"];
            }
        }
    }
}


#pragma mark -- get
- (NSMutableDictionary<CBPeripheral *,TBLEDevice *> *)devices {
    if (!_devices) {
        _devices = [[NSMutableDictionary alloc] init];
    }
    return _devices;
}

@end
