//
//  Tools.h
//  Cowa
//
//  Created by MX on 16/5/13.
//  Copyright © 2016年 MX. All rights reserved.
//

#ifndef Tools_h
#define Tools_h

    #import "TThirdPart.h"
    #import "TData.h"
    #import "GJTool.h"
    #import "FrendsModel.h"
    #import "SecurityUtil.h"
#import <CommonCrypto/CommonDigest.h>
#import "DeviceListCell.h"
#import "MMPDeepSleepPreventer.h"//播放音乐的类
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
//#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BMKLocationkit/BMKLocationComponent.h>
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件

#import <UMMobClick/MobClick.h>
#import <UIImage+GIF.h>

// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif


#endif /* Tools_h */
