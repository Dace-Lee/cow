//
//  TBLERssiHandle.m
//  CowaBLELib
//
//  Created by gaojun on 2018/9/12.
//  Copyright © 2018年 mx. All rights reserved.
//

#import "TBLERssiHandle.h"
#import "TBLENotification.h"

@interface TBLERssiHandle ()

@property(nonatomic,assign)NSNumber *rssi;
@property(nonatomic,strong)NSMutableArray *rssiArray;

@end

@implementation TBLERssiHandle

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
        
        self.rssi = [NSNumber numberWithDouble:0.0];
        self.rssiArray = [[NSMutableArray alloc] init];
        
    }
    return self;
}

- (void)judgeDistanceWith:(NSNumber *)rssi{
    [self.rssiArray addObject:rssi];
    
    if (self.rssiArray.count == 4) {
        [self.rssiArray removeObjectAtIndex:3];
        
        //平均值
        NSNumber *sum = [self.rssiArray valueForKeyPath:@"@sum.doubleValue"];
        double average = [sum doubleValue] / 3;
        
        if (fabs([rssi doubleValue]) < fabs(average)) {
            //发通知
            [[NSNotificationCenter defaultCenter] postNotificationName:kCowaBLENotiDistanceFaraway object:nil];
        }else{
             [[NSNotificationCenter defaultCenter] postNotificationName:@"kCowaBLENotiDistanceNear" object:nil];
        }
        
        NSLog(@"%f",fabs([rssi doubleValue]));
        
        [self.rssiArray addObject:rssi];
        [self.rssiArray removeObjectAtIndex:0];
    }
}

@end
