//
//  HexTool.h
//  CowaBLE
//
//  Created by gaojun on 2017/9/13.
//  Copyright © 2017年 mx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HexTool : NSObject
+(NSString *)create32HexStartWith80:(NSString *)str;
+(NSString *)create32Hex:(NSString *)str;
+(NSString *)create16Hex:(NSString *)str;
@end
