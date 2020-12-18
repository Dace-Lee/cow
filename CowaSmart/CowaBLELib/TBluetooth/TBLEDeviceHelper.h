//
//  TBLEDeviceHelper.h
//  CowaBLE
//
//  Created by MX on 2016/10/25.
//  Copyright © 2016年 mx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBLEDeviceHelper : NSObject
+ (NSString *)transferMac:(NSDictionary *)advertisement;

+ (NSString *)assemble:(NSString *)command;
+ (NSString *)assemble:(NSString *)command para:(NSString *)para;
+ (NSString *)assemble:(NSString *)command paraValue:(BOOL)para;

@end

