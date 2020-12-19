//
//  BMKWalkCycleLocationService.h
//  BaiduMapAPI_WalkNavi
//
//  Created by Xin,Qi on 2018/8/7.
//  Copyright © 2018 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Base/BMKUserLocation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#ifndef __IPHONE_14_0
#define __IPHONE_14_0 140000
#endif
/// 定位服务Delegate,调用startUserLocationService定位成功后，用此Delegate来获取定位数据
@protocol BMKWalkCycleLocationServiceDelegate <NSObject>
@optional
/**
 *在将要启动定位时，会调用此函数
 */
- (void)willStartLocatingUser;

/**
 *在停止定位后，会调用此函数
 */
- (void)didStopLocatingUser;

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *_Nullable)userLocation;

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *_Nullable)userLocation;

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *_Nullable)error;
@end

/// 定位服务权限申请Delegate,建议开发者也可以自行在调用步骑行导航前根据需求申请相关权限。
@protocol BMKWalkCycleLocationServiceAuthorizationDelegate <NSObject>
@optional
/**
 *  @brief 为了适配app store关于新的后台定位的审核机制（app store要求如果开发者只配置了使用期间定位，则代码中不能出现申请后台定位的逻辑），当开发者在plist配置NSLocationAlwaysUsageDescription或者NSLocationAlwaysAndWhenInUseUsageDescription时，需要在该delegate中调用后台定位api：[locationManager requestAlwaysAuthorization]。开发者如果只配置了NSLocationWhenInUseUsageDescription，且只有使用期间的定位需求，则无需在delegate中实现逻辑。
 *  @param locationManager 系统 CLLocationManager 类 。
 *  @since 5.0.0
 */
- (void)doRequestAlwaysAuthorization:(CLLocationManager * _Nonnull)locationManager;

/**
 *  @brief 为了适配iOS14，开发者如果想在其他地方使用低定精度定位，进入步骑行导航前需配合在plist配置
    <key>NSLocationTemporaryUsageDescriptionDictionary</key>
    <dict>
        <key>WantsToNavigate</key>
        <string>步骑行导航需要高精度定位权限</string>
    </dict>
 *  并delegate中调用api：[locationManager requestTemporaryFullAccuracyAuthorizationWithPurposeKey:@"WantsToNavigate"]申请一次高精度精度权限用于步骑行导航。
 *  @param locationManager 系统 CLLocationManager 类 。
 *  @since 6.0.0
 */
- (void)doRequestTemporaryFullAccuracyAuthorization:(CLLocationManager * _Nonnull)locationManager;
@end

@interface BMKWalkCycleLocationService : NSObject

/// 当前用户位置，返回坐标类型为当前设置的坐标类型
@property (nonatomic, readonly) BMKUserLocation * _Nullable userLocation;

/// 定位服务Delegate,调用startUserLocationService定位成功后，用此Delegate来获取定位数据
@property (nonatomic, weak) id<BMKWalkCycleLocationServiceDelegate> _Nullable delegate;

/**
  步骑行导航定位权限授权代理
  */
@property (nonatomic, weak) id<BMKWalkCycleLocationServiceAuthorizationDelegate> _Nullable locationAuthorizationDelegate;

/**
 *打开定位服务
 *需要在info.plist文件中添加(以下二选一，两个都添加默认使用NSLocationWhenInUseUsageDescription)：
 *NSLocationWhenInUseUsageDescription 允许在前台使用时获取GPS的描述
 *NSLocationAlwaysUsageDescription 允许永远可获取GPS的描述
 */
-(void)startUserLocationService;
/**
 *关闭定位服务
 */
-(void)stopUserLocationService;

#pragma mark - 定位参数，具体含义可参考CLLocationManager相关属性的注释

/// 设定定位的最小更新距离。默认为kCLDistanceFilterNone
@property(nonatomic, assign) CLLocationDistance distanceFilter;

/// 设定定位精度。默认为kCLLocationAccuracyBest。
@property(nonatomic, assign) CLLocationAccuracy desiredAccuracy;

/// 设定最小更新角度。默认为1度，设定为kCLHeadingFilterNone会提示任何角度改变。
@property(nonatomic, assign) CLLocationDegrees headingFilter;

/// 指定定位是否会被系统自动暂停。默认为YES。只在iOS 6.0之后起作用。
@property(nonatomic, assign) BOOL pausesLocationUpdatesAutomatically;

///指定定位：是否允许后台定位更新。默认为NO。只在iOS 9.0之后起作用。设为YES时，Info.plist中 UIBackgroundModes 必须包含 "location"
@property(nonatomic, assign) BOOL allowsBackgroundLocationUpdates;

@end
