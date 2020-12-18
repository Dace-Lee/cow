//
//  TBLENotification.h
//  CowaBLE
//
//  Created by MX on 2016/10/31.
//  Copyright © 2016年 mx. All rights reserved.
//

#ifndef TBLENotification_h
#define TBLENotification_h

/*!
 *	@brief 通知电源改变
 */
extern NSString * const kBluetoothNotiPowerChanged;
/*!
 *	@brief 通知感知的设备数量改变
 */
extern NSString * const kBluetoothNotiDeviceChanged;

/*!
 *	@brief 设备状态更新(设备的各种锁的状态之类)
 */
extern NSString * const kBLENotiStatusUpdate;

/*!
 *	@brief 设备状态改变(设备连接或者准备状态改变，确定了设备是否可以被操作)(现在添加参数dic, {@"device":TBLEDevice})
 */
extern NSString * const kBLENotiStatusChanged;

/*!
 *	@brief 通知设备的连接状态改变，为了识别断电设备关闭的情况
 */
extern NSString * const kBLENotiDeviceConnectChanged;

/*!
 *	@brief 设备的信号强度变化
 */
extern NSString * const kBLENotiRSSIChanged;

/*!
 *	@brief 设备接受到新的数据
 */
extern NSString * const kBLENotiReciveNewData;

/*!
 *	@brief 获取到IMEI串号
 */
extern NSString * const kBLENotiGetIMEIString;

/*!
 *	@brief Cowa设备距离感应改变
 */
extern NSString * const kCowaBLENotiDistanceChanged;

/*!
 *	@brief Cowa设备距离过远(默认的设置)
 */
extern NSString * const kCowaBLENotiDistanceFaraway;

/*!
 *	@brief Cowa设备电量过低(默认的设置)
 */
extern NSString * const kCowaBLENotiBatteryLow;

#endif
