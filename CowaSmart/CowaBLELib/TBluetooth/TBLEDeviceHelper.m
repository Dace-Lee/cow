//
//  TBLEDeviceHelper.m
//  CowaBLE
//
//  Created by MX on 2016/10/25.
//  Copyright © 2016年 mx. All rights reserved.
//

#import "TBLEDeviceHelper.h"

@implementation TBLEDeviceHelper
+ (NSString *)transferMac:(NSDictionary *)advertisement {
    if (advertisement) {
     
        id menuData = [advertisement valueForKey:@"kCBAdvDataManufacturerData"];
        if (!menuData) { return @""; }
        if ([menuData isKindOfClass:[NSData class]]) {
            NSData *macData = (NSData *)menuData;
            NSString *value = [NSString stringWithFormat:@"%x", macData];
           
            NSMutableString *macString = [[NSMutableString alloc] init];
            int rangs[4] = {0,2,4,6};
            for (int i = 0; i <= 3; i++) {
                [macString appendString:[[value substringWithRange:NSMakeRange(rangs[i], 2)] uppercaseString]];
                [macString appendString:@":"];
                //NSLog(@"%@",macString);
            }
            NSString *mac = [macString substringToIndex:macString.length - 1];
            //NSLog(@"设备mac地址是:%@", mac);
            return mac;
        }
    }
    return @"";

}

+ (NSString *)assemble:(NSString *)command {
    return [[self class] assemble:command para:nil];
}

+ (NSString *)assemble:(NSString *)command para:(NSString *)para {
    NSMutableString *com = [NSMutableString stringWithFormat:@"%@:", command];
    if (para) {
        [com appendString:para];
    }
    [com appendString:@"\r\n"];
    return com;
}

+ (NSString *)assemble:(NSString *)command paraValue:(BOOL)para {
    return [[self class] assemble:command para:para ? @"1" : @"0"];
}


@end
