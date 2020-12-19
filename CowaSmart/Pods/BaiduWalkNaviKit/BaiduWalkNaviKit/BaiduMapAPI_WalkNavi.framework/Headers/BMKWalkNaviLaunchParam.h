//
//  BMKWalkNaviLaunchParam.h
//  WalkCycleComponent
//
//  Created by Xin,Qi on 24/01/2018.
//  Copyright © 2018 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "BMKWalkCycleDefine.h"


/**
 算路起始点设置类
 */
@interface BMKWalkNaviLaunchParam : NSObject

/**
 算路起点
 */
@property (nonatomic, assign) CLLocationCoordinate2D startPoint;

/**
 算路终点
 */
@property (nonatomic, assign) CLLocationCoordinate2D endPoint;

/// 步行导航模式设置该参数即可（默认普通步行导航）
/// BMK_WALK_NAVIGATION_MODE_WALK_NORMAL: 普通步行导航
/// BMK_WALK_NAVIGATION_MODE_WALK_AR: AR步行导航
@property (nonatomic, assign) BMKWalkNavigationMode extraNaviMode;


@end
