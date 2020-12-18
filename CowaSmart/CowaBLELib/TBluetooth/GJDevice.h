//
//  GJDevice.h
//  CowaRBTest
//
//  Created by gaojun on 2016/11/15.
//  Copyright © 2016年 Fan ren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>


@interface GJDevice : NSObject
{
    NSData *_lastData;
}

@property(assign,nonatomic)int index;
@property(assign,nonatomic)int fileIndex;

+(GJDevice *)sharedInstance;
-(NSMutableData *)sendFileDataWithName:(NSString *)name AndSize:(NSUInteger)size Type:(NSString *)type MD5Str:(NSString *)md5;
-(NSData *)sendFileData:(NSData *)data Type:(NSString *)type;
-(NSData *)sendLastData;
-(NSData *)sendEOTWithData;

@end

