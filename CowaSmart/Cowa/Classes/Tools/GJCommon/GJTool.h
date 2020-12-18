//
//  GJTool.h
//  Cowa
//
//  Created by gaojun on 2016/12/21.
//  Copyright © 2016年 MX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GJTool : NSObject

+(NSString *)getMD5CodeWithString:(NSString *)str;

+(NSArray*)stringChangeToArray:(NSString*)string;

+(BOOL)validateCellPhoneNumber:(NSString *)cellNum;

+(NSString *)ToHex:(long long int)tmpid;

+(uint16_t)crc16:(unsigned char *)updata :(unsigned int )len;

+ (NSData *)convertHexStrToData:(NSString *)str;

+ (NSString*)arrayChangeToString:(NSArray*)array withSplit:(NSString*)split;

+ (NSString*)getMD5WithData:(NSData *)data;

+(NSString*)getFileMD5WithPath:(NSString*)path;

//数组排序
+(NSArray *)arraySorted:(NSArray *)array;

+(void)nslog:(NSString *)str;

@end
