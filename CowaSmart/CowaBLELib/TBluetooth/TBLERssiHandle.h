//
//  TBLERssiHandle.h
//  CowaBLELib
//
//  Created by gaojun on 2018/9/12.
//  Copyright © 2018年 mx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBLERssiHandle : NSObject

+ (instancetype)shareBluetooth;

- (void)judgeDistanceWith:(NSNumber *)rssi;

@end
