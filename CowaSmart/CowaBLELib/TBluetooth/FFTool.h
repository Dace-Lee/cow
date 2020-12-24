//
//  FFTool.h
//  CowaBLE
//
//  Created by gaojun on 2017/9/13.
//  Copyright © 2017年 mx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFTool : NSObject

+(NSString *)getMD5CodeWithString:(NSString *)str;

+(NSArray*)stringChangeToArray:(NSString*)string;

+(BOOL)validateCellPhoneNumber:(NSString *)cellNum;

+(NSString *)ToHex:(long long int)tmpid;

+(uint16_t)crc16:(unsigned char *)updata :(unsigned int )len;

+ (NSData *)convertHexStrToData:(NSString *)str;

+ (NSString*)arrayChangeToString:(NSArray*)array withSplit:(NSString*)split;

+ (NSString*)getMD5WithData:(NSData *)data;

+(NSString*)getFileMD5WithPath:(NSString*)path;

//十六进制字符串转成NSData
+(NSMutableData *)chengeHexToDataWithString:(NSString *)str withType:(int)type;

+ (NSMutableData *)hexStringToData:(NSString *)str;

+ (NSString *)dataToHexString:(NSData *)data;

//字符串转十六进制
+ (NSString *)hexStringFromString:(NSString *)string;

+(NSString *)To32:(NSString *)str;

//数组排序
+(NSArray *)arraySorted:(NSArray *)array;
//十六进制转字符串
+ (NSString *)stringFromHexString:(NSString *)hexString;

//字符串翻转
+(NSString *)convertString:(NSString *)str withSlipt:(NSString *)slipt;

@end
