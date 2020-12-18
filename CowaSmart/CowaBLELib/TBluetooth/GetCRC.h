//
//  GetCRC.h
//  CowaBLE
//
//  Created by gaojun on 2017/9/13.
//  Copyright © 2017年 mx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetCRC : NSObject

+(uint)getCRCWith:(u_char *)updata :(uint)len;

+(uint16_t)crc16:(unsigned char *)updata :(unsigned int )len;

@end
