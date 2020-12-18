//
//  TBLEDevice.m
//  Cowa
//
//  Created by MX on 16/8/8.
//  Copyright © 2016年 MX. All rights reserved.
//

#import <objc/runtime.h>
#import "TBLEDevice.h"
#import "TBLEDefines.h"
#import "TBluetooth.h"
#import "TBLEDeviceHelper.h"
#import "TBLENotification.h"

#define SleepTimeGap 0.05

@interface TBLEDevice ()

@end

@implementation TBLEDevice

#pragma mark -- set
- (void)setConnect:(BOOL)connect {
    _isConnect = connect;
    [self notify:kBLENotiDeviceConnectChanged];
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    if (selected) {
        if (!self.isConnect)
        {
            [[TBluetooth shareBluetooth] connectTo:self.peri];
        }
    } else {    

        [[TBluetooth shareBluetooth] cancelConnect:self.peri];
    }
}

- (void)judgeDeviceIsReady {
    if ([TBluetooth shareBluetooth].cmdService && [TBluetooth shareBluetooth].peripheral && self.isConnect && [TBluetooth shareBluetooth].peripheral.state == CBPeripheralStateConnected) {
        [self setIsReady:YES];
    } else {
        [self setIsReady:NO];
    }
}

- (void)setIsReady:(BOOL)isReady {
    _isReady = isReady;
    
    if (_isReady){
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:self forKey:@"device"];
        NSNotification *noti = [[NSNotification alloc] initWithName:kBLENotiStatusChanged object:self userInfo:dic];
        [[NSNotificationCenter defaultCenter] postNotification:noti];
    }
}

- (void)notify:(NSString *)name {
    if (self.selected && name) {
        [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil];
    }
}
@end

static const void * TBLEDeviceResponseKey = "TBLEDeviceResponseKey";
@implementation TBLEDevice (Command)
@dynamic response;

- (NSOperationQueue *)writeQueue {
    if (!_writeQueue) {
        _writeQueue = [[NSOperationQueue alloc] init];
        _writeQueue.maxConcurrentOperationCount = 1;
    }
    return _writeQueue;
}

- (BOOL)send:(NSMutableData *)data {
   
    if (data && [TBluetooth shareBluetooth].peripheral && [TBluetooth shareBluetooth].peripheral.state == CBPeripheralStateConnected) {
        
        NSBlockOperation *operate = [NSBlockOperation blockOperationWithBlock:^{
            [self writeData:data];
            //[NSThread sleepForTimeInterval:SleepTimeGap];
        }];
        
        [self.writeQueue addOperation:operate];
        
        return YES;
    }
    
    return NO;
    
}

//清空指令队列
-(void)deleteAllCommand
{
    [self.writeQueue cancelAllOperations];
}

- (void)writeData:(NSMutableData *)data {


    [[TBluetooth shareBluetooth].peripheral writeValue:data
        forCharacteristic:[TBluetooth shareBluetooth].cmdCha
                     type:CBCharacteristicWriteWithoutResponse];
    
    //NSLog(@"cmd:%@",data);

}

#pragma mark - 修改设备名和密码
-(void)setDeviceNameAndPwdWithData:(NSData *)data
{
    [[TBluetooth shareBluetooth].peripheral writeValue:data forCharacteristic:[TBluetooth shareBluetooth].dataCha type:CBCharacteristicWriteWithoutResponse];
}


- (void)setResponse:(NSData *)response {
    objc_setAssociatedObject(self, TBLEDeviceResponseKey, response, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self notify:kBLENotiReciveNewData];
}

- (NSData *)response {
    return (NSData *)objc_getAssociatedObject(self, TBLEDeviceResponseKey);
}

@end
