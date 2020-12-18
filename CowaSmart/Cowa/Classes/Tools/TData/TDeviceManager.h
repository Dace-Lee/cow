//
//  TDeviceManager.h
//  Cowa
//
//  Created by MX on 16/6/1.
//  Copyright © 2016年 MX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface MDevice : NSObject
@property (nonatomic, strong) NSNumber *device_id;
@property (nonatomic, copy) NSString *device_name;
@property (nonatomic, copy) NSString *device_mac;
@property (nonatomic, copy) NSString *device_IMEI;//sn
@property (nonatomic, copy) NSString *isHost;
@end

@interface TDeviceManager : NSObject
@property (nonatomic ,copy) NSString *dataRequestToken;
@property (nonatomic ,strong) NSMutableArray <MDevice *>* devices;
+ (instancetype)sharedDeviceManager;

@end

@interface TDeviceManager (CoreData)
- (void)localAddDevice:(MDevice *)device;
- (void)localChangeDevice:(MDevice *)device;
- (NSArray <MDevice *>*)localGetDevices;
- (void)localDeleteDevice:(MDevice *)deivce;

+ (MDevice *)deviceWithMac:(NSString *)macAddress;
+ (NSString *)getDevNameWithMac:(NSString *)macAddress;
+ (NSString *)getDevSNWithMac:(NSString *)macAddress;
@end
