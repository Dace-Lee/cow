//
//  TDeviceManager.m
//  Cowa
//
//  Created by MX on 16/6/1.
//  Copyright © 2016年 MX. All rights reserved.
//

#import "TDeviceManager.h"
#import "TDataManager.h"
#import <objc/runtime.h>
#import "Cowa-Swift.h"

@interface MDevice_CoreData : NSManagedObject
@property (nonatomic ,strong) NSNumber *device_id;
@property (nonatomic ,copy) NSString *device_name;
@property (nonatomic ,copy) NSString *device_mac;
@property (nonatomic, copy) NSString *device_IMEI;//sn
@property (nonatomic, copy) NSString *isHost;
@end
@interface MDevice ()
- (void)createCoreDataModel:(MDevice_CoreData *)cdModel;
+ (MDevice *)generateModelWith:(MDevice_CoreData *)m;
@end
@implementation MDevice
- (void)createCoreDataModel:(MDevice_CoreData *)cdModel {
    unsigned int proCount = 0;
    objc_property_t *propertys = class_copyPropertyList([self class], &proCount);
    for (int i = 0; i < proCount; i ++) {
        const char *n = property_getName(propertys[i]);
        NSString *name = [NSString stringWithUTF8String:n];
        [cdModel setValue:[self valueForKeyPath:name] forKeyPath:name];
    }
}

+ (MDevice *)generateModelWith:(MDevice_CoreData *)m {
    MDevice *model = [[MDevice alloc] init];
    [model createCoreDataModel:m];
    return model;
}

@end

@implementation MDevice_CoreData
@synthesize device_id = _device_id;
@synthesize device_mac = _device_mac;
@synthesize device_name = _device_name;
@synthesize device_IMEI = _device_IMEI;
@synthesize isHost = _isHost;
@end

@implementation TDeviceManager
+ (instancetype)sharedDeviceManager {
    static id shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[[self class] alloc] init];
    });
    return shared;
}
@end

@implementation TDeviceManager(CoreData)
static NSString *kEntityNameDevice = @"Device";

- (void)localAddDevice:(MDevice *)device {
    TDataManager *m = [TDataManager sharedDataManager];
    MDevice_CoreData *d = [NSEntityDescription insertNewObjectForEntityForName:kEntityNameDevice inManagedObjectContext:m.managedObjectContext];
    [device createCoreDataModel:d];
    [m saveContext];
}

- (void)localChangeDevice:(MDevice *)device {
    NSArray *arr = [self requestCoreDataModels];
    for (MDevice_CoreData *m in arr) {
        if ([device.device_mac isEqualToString:m.device_mac]) {
            m.device_id = device.device_id;
            m.device_name = device.device_name;
            m.device_IMEI = device.device_IMEI;
        }
    }
    [[TDataManager sharedDataManager] saveContext];
}

- (NSArray <MDevice *>*)localGetDevices {
    NSArray *arr = [self requestCoreDataModels];
    NSMutableArray *models = [[NSMutableArray alloc] init];
    for (MDevice_CoreData *m in arr) {
        [models addObject:[MDevice generateModelWith:m]];
    }
    return models;
}

- (void)localDeleteDevice:(MDevice *)deivce {
    TDataManager *m = [TDataManager sharedDataManager];
    NSArray *arr = [self requestCoreDataModels];
    for (MDevice_CoreData *m in arr) {
        if ([deivce.device_mac isEqualToString:m.device_mac]) {
            [m.managedObjectContext deleteObject:m];
        }
    }
    [m saveContext];
}

- (NSArray *)requestCoreDataModels {
    TDataManager *m = [TDataManager sharedDataManager];
    NSFetchRequest *req = [[NSFetchRequest alloc] init];
    [req setEntity:[NSEntityDescription entityForName:kEntityNameDevice inManagedObjectContext:m.managedObjectContext]];
    NSError *error;
    NSArray *arr = [m.managedObjectContext executeFetchRequest:req error:&error];
    return arr;
}

+ (NSString *)getDevNameWithMac:(NSString *)macAddress {
    if (macAddress) {
        return [[self class] deviceWithMac:macAddress].device_name;
    }
    return nil;
}

+ (NSString *)getDevSNWithMac:(NSString *)macAddress {
    if (macAddress) {
        return [[self class] deviceWithMac:macAddress].device_IMEI;
    }
    return nil;
}

+ (MDevice *)deviceWithMac:(NSString *)macAddress {
    if (macAddress) {
        NSArray<MDevice *> *arr = [[TDeviceManager sharedDeviceManager] localGetDevices];
        for (MDevice *dev in arr) {
            if ([dev.device_mac isEqualToString:macAddress]) {
                return dev;
            }
        }
    }
    return nil;
}

@end
