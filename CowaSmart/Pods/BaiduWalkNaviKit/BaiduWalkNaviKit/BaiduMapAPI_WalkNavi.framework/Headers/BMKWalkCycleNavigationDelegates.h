//
//  BMKWalkCycleNavigationDelegates.h
//  WalkNaviComponent
//
//  Created by Xin,Qi on 28/03/2018.
//  Copyright © 2018 Baidu. All rights reserved.
//

#ifndef BMKWalkCycleNavigationDelegates_h
#define BMKWalkCycleNavigationDelegates_h
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BMKWalkCycleDefine.h"

#pragma mark - 步行导航算路代理类
/**
 步骑行导航算路代理类
 */
@protocol BMKWalkCycleRoutePlanDelegate <NSObject>

@optional
/**
 开始算路
 */
- (void)onRoutePlanStart:(BMKWalkCycleNavigationType)naviType;

/**
 算路结果返回
 
 @param errorCode 错误码
 */
- (void)onRoutePlanResult:(BMKWalkCycleRoutePlanErrorCode)errorCode naviType:(BMKWalkCycleNavigationType)naviType;

@end

#pragma mark - 步行导航诱导信息代理类
/**
 步骑行导航诱导信息代理类
 */
@protocol BMKWalkCycleRouteGuidanceDelegate <NSObject>

@optional
/**
 诱导图标更新
 
 @param icon 诱导图标
 */
- (void)onRouteGuideIconUpdate:(UIImage *)icon naviType:(BMKWalkCycleNavigationType)naviType;

/**
 诱导枚举信息
 
 @param guideKind 诱导信息
 */
- (void)onRouteGuideKind:(BMKWalkCycleGuideKind)guideKind naviType:(BMKWalkCycleNavigationType)naviType;

/**
 诱导信息
 
 @param firstSequence 第一行显示的信息，比如“沿当前道路”
 @param secondSequence 第二行显示的信息，比如“向东出发”，第二行信息也可能为空
 */
- (void)onRoadGuideTextUpdateFirst:(NSString *)firstSequence second:(NSString *)secondSequence naviType:(BMKWalkCycleNavigationType)naviType;

/**
 总的剩余时间
 
 @param remainTime 剩余时间，已经带有单位
 */
- (void)onRemainTimeUpdate:(NSString *)remainTime naviType:(BMKWalkCycleNavigationType)naviType;

/**
 总的剩余距离
 
 @param remainDistance 剩余距离，已经带有单位
 */
- (void)onRemainDistanceUpdate:(NSString *)remainDistance naviType:(BMKWalkCycleNavigationType)naviType;

/**
 GPS状态发生变化，来自诱导引擎的消息
 
 @param gspInfo GPS信息
 @param guideIcon GPS诱导图标
 */
- (void)onGpsStatusChange:(NSString *)gspInfo guideIcon:(UIImage *)guideIcon naviType:(BMKWalkCycleNavigationType)naviType;

/**
 已经开始偏航
 
 @param rarAwayInfo 偏航信息
 @param guideIcon 偏航诱导图标
 */
- (void)onRouteFarAway:(NSString *)rarAwayInfo guideIcon:(UIImage *)guideIcon naviType:(BMKWalkCycleNavigationType)naviType;

/**
 偏航规划中
 
 @param yawingInfo 偏航规划中的信息
 @param guideIcon 偏航诱导图标
 */
- (void)onRoutePlanYawing:(NSString *)yawingInfo guideIcon:(UIImage *)guideIcon naviType:(BMKWalkCycleNavigationType)naviType;

/**
 重新算路成功
 */
- (void)onReRouteComplete:(BMKWalkCycleNavigationType)naviType;

/**
 重新算路失败
 */
- (void)onReRouteFail:(BMKWalkCycleNavigationType)naviType;

/**
 到达目的地
 */
- (void)onArriveDest:(BMKWalkCycleNavigationType)naviType;

/**
 震动
 */
- (void)onVibrate:(BMKWalkCycleNavigationType)naviType;

@end

#pragma mark - 步行导航TTS语音播报代理类
/**
 步骑行导航TTS语音播报代理类
 */
@protocol BMKWalkCycleTTSPlayerDelegate <NSObject>

@optional

/**
 诱导文本回调
 
 @param text 诱导文本
 @param prior 是否抢先播报
 */
- (void)onPlayTTSText:(NSString *)text prior:(BOOL)prior naviType:(BMKWalkCycleNavigationType)naviType;

@end

@protocol BMKWalkCycleLocationServiceDelegate <NSObject>
@optional
/**
 *  @brief 为了适配app store关于新的后台定位的审核机制（app store要求如果开发者只配置了使用期间定位，则代码中不能出现申请后台定位的逻辑），当开发者在plist配置NSLocationAlwaysUsageDescription或者NSLocationAlwaysAndWhenInUseUsageDescription时，需要在该delegate中调用后台定位api：[locationManager requestAlwaysAuthorization]。开发者如果只配置了NSLocationWhenInUseUsageDescription，且只有使用期间的定位需求，则无需在delegate中实现逻辑。
 *  @param locationManager 系统 CLLocationManager 类 。
 *  @since 5.0.0
 */
- (void)doRequestAlwaysAuthorization:(CLLocationManager * _Nonnull)locationManager DEPRECATED_MSG_ATTRIBUTE("定位权限需要开发者主动申请");

/**
 步骑行导航定位服务错误码
 
 @param errorCode 错误对象
 */
- (void)onLocationServiceError:(BMKWalkCycleNavigationLocationServiceErrorCode)errorCode;

@end
#endif /* BMKWalkCycleNavigationDelegates_h */
