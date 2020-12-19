//
//  BMKWalkCycleNavigationDisplayOption.h
//  BaiduMapAPI_WalkNavi
//
//  Created by Xin,Qi on 2018/7/28.
//  Copyright © 2018 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BMKWalkCycleDefine.h"

@class BMKWalkCycleNaviContentDisplayOption;
@class BMKWalkCycleNaviLocationDisplayOption;
@class BMKWalkCycleNaviTabBarDisplayOption;
@class BMKWalkNaviCalorieDisplayOption;
@class BMKCycleNaviZoomDisplayOption;
@class BMKCycleNaviDashboardDisplayOption;

/// 步骑行导航定制化设置类。
/// 此类提供对步骑行导航页面元素和导航行为进行个性化定制的能力。
@interface BMKWalkCycleNavigationDisplayOption : NSObject

/// 导航页面右下角进入AR导航模式图标
@property (nonatomic, strong) UIImage *walkARModeIcon;

/// 导航页面右下角进入普通导航模式图标
@property (nonatomic, strong) UIImage *walkNormalModeIcon;

/// 是否支持结束导航自动弹窗提示，默认值为YES。
@property (nonatomic, assign) BOOL supportEndPopup;

 
/// 导航页面顶部诱导图层 since 5.3.0
@property (nonatomic, strong) BMKWalkCycleNaviContentDisplayOption *walkCycleNaviContentDisplayOption;

/// 导航页面左下角的导航标记 since 5.3.0
@property (nonatomic, strong) BMKWalkCycleNaviLocationDisplayOption *walkCycleNaviLocationDisplayOption;

/// 导航页面底部tabBar since 5.3.0
@property (nonatomic, strong) BMKWalkCycleNaviTabBarDisplayOption *walkCycleNaviTabBarDisplayOption;

/// 步行导航页面卡路里图层 since 5.3.0
@property (nonatomic, strong) BMKWalkNaviCalorieDisplayOption *walkNaviCalorieDisplayOption;

/// 骑行导航页面的放大缩小控件 since 5.3.0
@property (nonatomic, strong) BMKCycleNaviZoomDisplayOption *cycleNaviZoomDisplayOption;

/// 骑行导航页面仪表盘控件 since 5.3.0
@property (nonatomic, strong) BMKCycleNaviDashboardDisplayOption *cycleNaviDashboardDisplayOption;

@end


/// 导航页面顶部诱导图层
@interface BMKWalkCycleNaviContentDisplayOption : NSObject

/// 背景色
@property (nonatomic, strong) UIColor *backgroundColor;

/// 背景图片
/// width = [UIScreen mainScreen].bounds.size.width - 20
/// height = [UIScreen mainScreen].bounds.size.width / 3.4
@property (nonatomic, strong) UIImage *backgroundIcon;


/// 诱导信息文本颜色
@property (nonatomic, strong) UIColor *guideInfoTextColor;

/// 偏导航信息文本颜色
@property (nonatomic, strong) UIColor *yaWingInfoTextColor;

@end

/// 导航页面左下角的导航标记
@interface BMKWalkCycleNaviLocationDisplayOption : NSObject

/// 背景色
@property (nonatomic, strong) UIColor *backgroundColor;

/// 是否隐藏视图(默认NO)
@property (nonatomic, assign) BOOL hideLocation;

@end

/// 导航页面底部tabar
@interface BMKWalkCycleNaviTabBarDisplayOption : NSObject

/// 背景色
@property (nonatomic, strong) UIColor *backgroundColor;

/// 背景图片
/// width = [UIScreen mainScreen].bounds.size.width - 20
///  height = 50
@property (nonatomic, strong) UIImage *backgroundIcon;

/// 导航页面左下角退出按钮图标
@property (nonatomic, strong) UIImage *exitIcon;

/// 步行AR导航页面左下角退出按钮图标
@property (nonatomic, strong) UIImage *exitARIcon;

/// 查看全览文本颜色
@property (nonatomic, strong) UIColor *seeAllTextColor;

/// 剩余信息文本颜色
@property (nonatomic, strong) UIColor *remainInfoTextColor;

/// 继续导航文本颜色
@property (nonatomic, strong) UIColor *goOnTextColor;

@end

/// 步行导航页面卡路里图层
@interface BMKWalkNaviCalorieDisplayOption : NSObject

/// 是否隐藏卡路里视图(默认NO)
@property (nonatomic, assign) BOOL hideCalorie;

/// 背景图标
@property (nonatomic, strong) UIImage *backgroundImage;

@end

/// 骑行导航页面的放大缩小控件
@interface BMKCycleNaviZoomDisplayOption : NSObject

/// 是否隐藏(默认NO)
@property (nonatomic, assign) BOOL hideZoom;

/// 背景色
@property (nonatomic, strong) UIColor *backgroundColor;

/// 放大按钮图标
@property (nonatomic, strong) UIImage *zoomOutIcon;

/// 缩小按钮图标
@property (nonatomic, strong) UIImage *zoomInIcon;

/// 分割线颜色
@property (nonatomic, strong) UIColor *splitColor;

@end

/// 骑行导航页面仪表盘控件
@interface BMKCycleNaviDashboardDisplayOption : NSObject

/// 是否隐藏(默认NO)
@property (nonatomic, assign) BOOL hideDashboard;

/// 背景色
@property (nonatomic, strong) UIColor *backgroundColor;

/// 速度文本色
@property (nonatomic, strong) UIColor *speedInfoColor;

@end
