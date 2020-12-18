//
//  TBLEDeviceDistance.h
//  CowaBLE
//
//  Created by MX on 2016/10/31.
//  Copyright © 2016年 mx. All rights reserved.
//

#import <Foundation/Foundation.h>
#define triggerCount 1
typedef enum {
    far = -1,
    no_dir = 0,
    closer = 1
} distance_direction;

@class TBLEDevice;
@interface TBLEDeviceDistance : NSObject
+ (double)distanceFrom:(NSNumber *)RSSI;

@property (nonatomic, retain) TBLEDevice *device;
@property (nonatomic, assign) NSNumber *RSSI;
@property (nonatomic, assign) double distance;
@property (nonatomic, assign) distance_direction direction;
@property (nonatomic, assign) double farDistanceTrigger;
@property (nonatomic, assign) double closerDistanceTrigger;
@property (nonatomic, strong) void (^distanceChanged)(double distance, distance_direction dir);

@end
