//
//  TBLEDeviceDistance.m
//  CowaBLE
//
//  Created by MX on 2016/10/31.
//  Copyright © 2016年 mx. All rights reserved.
//

#import "TBLEDeviceDistance.h"
#import "TBLEDevice.h"
#import "TBLEDefines.h"
#import <objc/runtime.h>
#import "TBLERssiHandle.h"

@interface TBLEDeviceDistance ()
@property (nonatomic, assign) int count;
@end

@implementation TBLEDeviceDistance

+ (double)distanceFrom:(NSNumber *)RSSI {
    double d = pow(10.0, (fabs(RSSI.doubleValue) - 59) / 20);
    //NSLog(@"信号强度%@--换算距离:%.4f", RSSI, d);
    return d;
}

- (id)init {
    if (self = [super init]) {
        self.farDistanceTrigger = 3.5;
        self.closerDistanceTrigger = 3;
    }
    return self;
}

- (void)dealloc {
    [self removeObserver:self.device];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([object isEqual:self.device] && [keyPath isEqualToString:@"RSSI"]) {
        @try {
            [self setRSSI:(NSNumber *)[change objectForKey:@"new"]];
        } @catch (NSException *exception) {
            
        } @finally {}
    }
}

- (void)addObserver:(TBLEDevice *)obj {

    [obj addObserver:self forKeyPath:@"RSSI" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserver:(TBLEDevice *)obj {
    @try {
        [obj removeObserver:self forKeyPath:@"RSSI"];

    } @catch (NSException *exception) {

    } @finally {}
}
#pragma mark - setter
- (void)setDevice:(TBLEDevice *)device {
    TBLEDevice *lastDevice = _device;
    _device = device;
    if (![lastDevice isEqual:_device]) {
        [self removeObserver:lastDevice];
        [self addObserver:_device];
    }
}

- (void)setDistance:(double)distance {
    _distance = distance;
    if (_distance <= _closerDistanceTrigger) {
        self.count -= 1;
    } else if (_distance >= _farDistanceTrigger) {
        self.count += 1;
    } else {
        self.count = 0;
    }
}

- (void)setRSSI:(NSNumber *)RSSI {
    _RSSI = RSSI;
    
    [[TBLERssiHandle shareBluetooth] judgeDistanceWith:RSSI];
    
    self.distance = [TBLEDeviceDistance distanceFrom:_RSSI];
}

- (void)setCount:(int)count {
    _count = count;
    distance_direction dir = no_dir;
    if (_count <= -triggerCount) {
        _count = -triggerCount;
        dir = closer;
    } else if (_count >= triggerCount) {
        _count = triggerCount;
        dir = far;
    }
    _direction = dir;
    if (self.distanceChanged) {
        self.distanceChanged(self.distance, dir);
    }
}

@end
